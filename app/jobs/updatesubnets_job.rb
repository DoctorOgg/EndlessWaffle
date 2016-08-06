class UpdatesubnetsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    fog_connection = Fog::Compute.new({
      :provider                 => 'AWS',
      :aws_access_key_id        => AWS_CONFIG["aws_access_key_id"],
      :aws_secret_access_key    => AWS_CONFIG["aws_secret_access_key"]
    })
    fog_connection.subnets.all.each do  |member|
      if Subnet.where(subnet_id: member.subnet_id).exists?
        record = Subnet.where(subnet_id: member.subnet_id).first
      else
        record = Subnet.new
      end

      record.subnet_id = member.subnet_id
      record.state = member.state
      record.vpc_id = member.vpc_id
      record.cidr_block = member.cidr_block
      record.available_ip_address_count = member.available_ip_address_count.to_i
      record.availability_zone = member.availability_zone
      record.tag_set = member.tag_set
      record.map_public_ip_on_launch = member.map_public_ip_on_launch
      record.save
    end


  end
end

# <Fog::Compute::AWS::Subnet
# subnet_id="subnet-xxx",
# state="available",
# vpc_id="vpc-xxx",
# cidr_block="xxxx",
# available_ip_address_count="4081",
# availability_zone="us-east-1b",
# tag_set={},
# map_public_ip_on_launch=true
# >,
