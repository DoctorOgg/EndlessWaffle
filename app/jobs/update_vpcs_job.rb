class UpdateVpcsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    fog_connection = Fog::Compute.new({
      :provider                 => 'AWS',
      :aws_access_key_id        => AWS_CONFIG["aws_access_key_id"],
      :aws_secret_access_key    => AWS_CONFIG["aws_secret_access_key"]
    })

    fog_connection.vpcs.all.each do |member|
      if Vpc.where(vpc_id: member.id).exists?
        record = Vpc.where(vpc_id: member.id).first
      else
        record = Vpc.new
        record.vpc_id = member.id
      end
      record.state = member.state
      record.cidr_block = member.cidr_block
      record.dhcp_options_id = member.dhcp_options_id
      record.tags = member.tags
      record.tenancy = member.tenancy
      record.save
    end

  end
end
