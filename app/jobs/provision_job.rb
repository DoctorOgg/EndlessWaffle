class ProvisionJob < ApplicationJob
  require 'pty'

  # before_enqueue
  # around_enqueue
  # after_enqueue
  # before_perform
  # around_perform
  # after_perform
  queue_as :default

  before_enqueue do |job|
    job_data = ProvisionJobDatum.new
    job_data.uuid = job.arguments[0][:uuid]
    job_data.arguments = job.arguments.to_s
    job_data.name = job.arguments[0][:name]
    job_data.environment = job.arguments[0][:environment]
    job_data.role = job.arguments[0][:role]
    job_data.status = "queued"
    job_data.save
  end

  after_perform do |job|
    job_data = ProvisionJobDatum.where(uuid: job.arguments[0][:uuid]).first
    job_data.status = "completed"
    job_data.save
  end

  def perform(*args)
    role_record = Role.where(name: arguments[0][:role]).first
    command_record = Command.where(name: role_record.provision_command).first
    command_filename = "/tmp/#{arguments[0][:uuid]}-#{$$}.sh"

    File.open(command_filename,"w") do |f|
      f.write(command_record.command)
    end
    File.chmod(0700,command_filename)

    r = REDIS.dup
    job_data = ProvisionJobDatum.where(uuid: args[0][:uuid]).first
    job_data.status = "running"
    job_data.save
    Buildlog.create([{:uuid => args[0][:uuid], :log => "running"}])
    build_parms = args[0].deep_symbolize_keys



    process_vars = {
      "AMI" => build_parms[:ami],
      "NAME" => build_parms[:name],
      "ROLE" => build_parms[:role],
      "ENVIRONMENT" => build_parms[:environment],
      "SECURITY_GROUPS" => build_parms[:security_groups].join(','),
      "UUID" => build_parms[:uuid],
      "CHEF_ROLE" => build_parms[:environment_config][:chef_role],
      "DISK_SIZE" => build_parms[:environment_config][:ami][:disk_size].to_s,
      "SSH_KEY_NAME" => build_parms[:environment_config][:ssh_key_name],
      "SSH_KEY_PATH" => build_parms[:environment_config][:ssh_key_path],
      "SSH_USER" => build_parms[:environment_config][:ami][:ssh_user],
      "INSTANCE_SIZE" => build_parms[:environment_config][:ami][:instance_size],
      "SUBNET_ID" => build_parms[:subnet][:subnet_id],
      "HOME" => ENV['HOME']
    }

    begin
      PTY.spawn(process_vars, command_filename, :unsetenv_others=>true, :chdir=>"/var/tmp" ) do |stdin, stdout, pid|
        begin
          stdin.each do |line|
            Buildlog.create([{:uuid => args[0][:uuid], :log => line}])
            r.publish args[0][:uuid], line
          end
        rescue Errno::EIO
          Buildlog.create([{:uuid => args[0][:uuid], :log => "Errno:EIO error, but this probably just means that the process has finished giving output"}])
        end
      end
    rescue PTY::ChildExited
      Buildlog.create([{:uuid => args[0][:uuid], :log => "The child process exited!"}])
    end
    Buildlog.create([{:uuid => args[0][:uuid], :log => "Ending job"}])

    job_data.save
    UpdateEc2Job.perform_later(AWS_CONFIG)
    FileUtils.rm command_filename

  end




end
