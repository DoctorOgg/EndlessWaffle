class Ec2provisionController < ApplicationController
  include ActionController::Live

  before_action :restrict_access, :except => [:watchjob]

  def watchjob
    if !params.key? :uuid
      render :json => {:error => "You Must Sepecify an UUID".to_json}, :status => 500; return
    end
    response.headers['Content-Type'] = 'text/event-stream'
    r = REDIS.dup

    r.subscribe(params[:uuid]) do |on|
      on.message do |channel, msg|

        if msg == "EOF"
          response.stream.write msg
          response.stream.close
          return
        else
          response.stream.write msg
        end

      end
    end

  end

  def showjobs
    pendingOrRunning = ProvisionJobDatum.select("uuid,environment,role,status,name,created_at").where("status != 'completed'")
    lastFiveCompleted = ProvisionJobDatum.select("uuid,environment,role,status,name,created_at").where("status = 'completed'").last(5)
    result = pendingOrRunning + lastFiveCompleted
    render :json => {:result => result}
  end

  def show
    if !params.key? :uuid
      render :json => {:error => "You Must Sepecify an UUID".to_json}, :status => 500; return
    end
    # data = ProvisionJobDatum.where(uuid: params[:uuid]).first
    data = Buildlog.select("log").where(uuid: params[:uuid]).order("id ASC")
    render :json => {:result => data}
  end

  def build
    pre_flight_errors = []
    pre_flight_errors.push "Specify role" unless params.key? :role
    pre_flight_errors.push "Specify environment" unless params.key? :environment
    pre_flight_errors.push "Specify availability_zone" unless params.key? :availability_zone
    if pre_flight_errors.length > 0
      render :json => {:errors => pre_flight_errors}.to_json, :status => 500; return
    end
    UpdateEc2Job.perform_now(AWS_CONFIG)

    role = params["role"]
    environment = params["environment"]
    availability_zone = params["availability_zone"]

    my_role = Role.where(name: role).first
    if my_role.nil?
      render :json => {:error => "Unable to find role with name: #{role}".to_json}, :status => 500; return
    end

    # Ok we have a role, but do we have an environment for this role?
    if !my_role.environments.key? environment
      render :json => {:error => "Unable to find enviroment for role with name: #{environment}".to_json}, :status => 500; return
    end

    my_enviroment = my_role.environments[environment]
    if my_enviroment["ami"].key? 'ami_id'
      my_ami_id = my_enviroment["ami"]['ami_id']
    else
      my_ami_id = find_ami(availability_zone,my_enviroment["ami"]["instance_type"],my_enviroment["ami"]["version"])['ami_id']
    end
    if my_ami_id.nil?
      render :json => {:error => "Unable to find AMI".to_json}, :status => 500; return
    end
    if my_ami_id.empty?
      render :json => {:error => "Unable to find AMI".to_json}, :status => 500; return
    end

    new_name = find_next_name(role, environment)

    my_subnet = find_subnet(availability_zone)
    if my_subnet.nil?
      render :json => {:error => "Unable to find Subnet".to_json}, :status => 500; return
    end

    my_security_groups=[]
    my_enviroment["security_groups"].each do |n|
      g = SecurityGroup.where(name: n).where(vpc_id: my_subnet.vpc_id).first
      my_security_groups.push(g.group_id)
    end
    if my_security_groups.empty?
      render :json => {:error => "Unable to lookup security_groups IDs".to_json}, :status => 500; return
    end

    # Let's make sure we can actually build this thing....
    # if !my_enviroment["ami"].key? 'ami_id'
    #   if !is_build_possable?(my_enviroment['ami']['instance_size'],my_ami_id)
    #     render :json => {:error => "The instance size (#{my_enviroment['ami']['instance_size']}) and ami selected (#{my_ami_id}) are not compatable, see: https://aws.amazon.com/amazon-linux-ami/instance-type-matrix/".to_json}, :status => 500; return
    #   end
    # end

    job_details = { :uuid => SecureRandom.uuid, :environment =>   environment, :role => role ,:name => new_name,:ami => my_ami_id, :subnet => my_subnet, :security_groups => my_security_groups, :environment_config=>my_enviroment}
    ProvisionJob.perform_later(job_details)
    render :json => job_details

  end

  private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.where(access_token: token).where(admin: true).first
    end
  end

  def find_next_name(role,environment)
    Rails.logger.info "Finding New name for role: #{role.to_s},environment: #{environment.to_s}"
    used_seq=[]
    Nodemap.where(environment: environment).where(role: role).each do |member|
       number = member.name.gsub(/[^\d]/, '').to_i
       used_seq.push member.name.gsub(/[^\d]/, '').to_i if number != 0
    end
    if used_seq.empty?
      "#{role}1"
    else
      full_seq = Array(1..used_seq.max)
      unused_number_in_seq = full_seq - used_seq
      unused_number_in_seq.empty? ? "#{role}#{full_seq.max+1}" : "#{role}#{unused_number_in_seq.min}"
    end
  end

  def find_ami(availability_zone,instance_type,version)
    Rails.logger.info "Finding AMI for availability_zone: #{availability_zone.to_s}, instance_type: #{instance_type.to_s}, version: #{version.to_s}"
    letters=Array('a'..'z')
    availability_zone = availability_zone[0..-2] if letters.include? availability_zone[-1]
    Ami.where(availability_zone: availability_zone).where(instance_type: instance_type).where(version: version).order('release DESC').first
  end

  def find_subnet(availability_zone)
    Rails.logger.info "finding subnet for availability_zone: #{availability_zone.to_s}"
    Subnet.where(availability_zone: availability_zone).where("available_ip_address_count > 0").first
  end

  def is_build_possable?(instance_size,selected_ami_id)
      virtualization_engine = ''
      storage_engine = ''
      family = instance_size.split('.')[0].downcase
      ami = Ami.where(ami_id: selected_ami_id).first

      if ami.instance_type.include? 'ebs'
        storage_engine = 'ebs'
      else
        storage_engine = 'instance'
      end

      if ami.instance_type.include? 'hvm'
        virtualization_engine = 'hvm'
      else
        virtualization_engine = 'pv'
      end
      result = AmiInstanceTypeMatrix.where(family: family).where(storage_engine: storage_engine).where(virtualization_engine: virtualization_engine)
      result.length > 1 ? true : false
  end

  def find_security_groups(names,vpc_id)
    Rails.logger.info "finding security groups for names: #{find_security_groups.join(',').to_s}, VPC: #{vpc_id.to_s}"
    result=[]
    names.each do |n|
      g = SecurityGroup.where(name: n).where(vpc_id: vpc_id).first
      result.push(g.group_id)
    end
    result
  end

end
