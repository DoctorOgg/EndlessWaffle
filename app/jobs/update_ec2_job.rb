class UpdateEc2Job < ApplicationJob
  queue_as :default


  def perform(*args)
    fog_connection = Fog::Compute.new({
      :provider                 => 'AWS',
      :aws_access_key_id        => args[0]["aws_access_key_id"],
      :aws_secret_access_key    => args[0]["aws_secret_access_key"]
    })
    known_machines=[]
    Ec2.select('instanceId').each do |member|
      known_machines.push member["instanceId"]
    end

    fog_connection.describe_instances.data[:body]["reservationSet"].each do |instance|
      if Ec2.where(instanceId: instance["instancesSet"][0]["instanceId"]).exists?
        record = Ec2.where(instanceId: instance["instancesSet"][0]["instanceId"]).first
      else
        record = Ec2.new
      end

      # remove machine from list if listed
      if known_machines.include? instance["instancesSet"][0]["instanceId"]
        known_machines.delete(instance["instancesSet"][0]["instanceId"])
      end

      instance["instancesSet"][0].each do |k,v|
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

    # we should update the reamining nodes listed in known_machines to mark them as terminated
    known_machines.each do |m|
      if Ec2.where(instanceId: m).exists?
        record = Ec2.where(instanceId: m).first
        record["instanceState"]["name"] = "terminated"
        nmap = record.nodemap
        nmap.instanceState = "terminated"
        nmap.save
        record.save
      end
    end


  end

end
