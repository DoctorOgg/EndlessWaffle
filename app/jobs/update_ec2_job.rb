class UpdateEc2Job < ApplicationJob
  queue_as :default


  def perform(*args)
    fog_connection = Fog::Compute.new({
      :provider                 => 'AWS',
      :aws_access_key_id        => AWS_CONFIG["aws_access_key_id"],
      :aws_secret_access_key    => AWS_CONFIG["aws_secret_access_key"]
    })

    fog_connection.describe_instances.data[:body]["reservationSet"].first["instancesSet"].each do |instance|
      if Ec2.where(instanceId: instance["instanceId"]).exists?
        record = Ec2.where(instanceId: instance["instanceId"]).first
      else
        record = Ec2.new
      end
      instance.each do |k,v|
        record[k] = v
      end
      # update our nodemaps
      if record.nodemap == nil
        nmap = Nodemap.new
        record.nodemap = nmap
      else
        nmap = record.nodemap
      end

      if record["tagSet"].key? "Name"
        nmap.name = record["tagSet"]["Name"]
      end

      if record["tagSet"].key? "environment"
        nmap.environment = record["tagSet"]["environment"]
      end

      if record["tagSet"].key? "role"
        nmap.role = record["tagSet"]["role"]
      end

      if record["instanceState"].key? "name"
        nmap.instanceState = record["instanceState"]["name"]
      end
      nmap.save

      # done
      record.save
    end
  end
end
