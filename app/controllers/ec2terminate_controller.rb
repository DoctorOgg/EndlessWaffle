class Ec2terminateController < ApplicationController
  before_action :restrict_access



  def terminate
    if !params.key? :instanceId
      render :json => {:error => "You Must Sepecify an instanceId".to_json}, :status => 500; return
    end
    query = Ec2.joins(:nodemap).where("\"nodemaps\".\"instanceState\" <> ?",'terminated').where("'instanceId' = ?", params[:instanceId]).first

    if query == nil
      render :json => {:error => "instanceId specified was not found or was already terminated".to_json}, :status => 500; return
    end

    result = goTerminateThyself(query.nodemap["role"],query.nodemap["environment"],query.nodemap["name"],query.instanceId)
    render :json => result
  end

  private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.where(access_token: token).where(admin: true).first
    end
  end

  def goTerminateThyself(role,environment,name,instanceId)
    log = []
    role_record = Role.where(name: role).first
    command_record = Command.where(name: role_record.terminate_command).first
    command_filename = "/tmp/ec2-terminate-#{instanceId}-#{$$}.sh"

    File.open(command_filename,"w") do |f|
      f.write(command_record.command)
    end

    process_vars = {
      "NAME" => name,
      "ROLE" => role,
      "ENVIRONMENT" => environment,
      "INSTANCEID" = instanceId
      "HOME" => ENV['HOME']
    }

    begin
      PTY.spawn(process_vars, command_filename, :unsetenv_others=>true, :chdir=>"/var/tmp" ) do |stdin, stdout, pid|
        begin
          stdin.each do |line|
            log.push line
          end
        rescue Errno::EIO
          log.push "Errno:EIO error, but this probably just means that the process has finished giving output"
        end
      end
    rescue PTY::ChildExited
      log.push "The child process exited!"
    end
    FileUtils.rm command_filename
    {:role => role, :environment => environment, :name => name, :instanceId => instanceId, :log => log}
  end

end
