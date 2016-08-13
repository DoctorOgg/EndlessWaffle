class UpdateSecurityGroupsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    fog_connection = Fog::Compute.new({
      :provider                 => 'AWS',
      :aws_access_key_id        => AWS_CONFIG["aws_access_key_id"],
      :aws_secret_access_key    => AWS_CONFIG["aws_secret_access_key"]
    })

    fog_connection.security_groups.all.each do |member|
      if SecurityGroup.where(group_id: member.group_id).exists?
        record = SecurityGroup.where(group_id: member.group_id).first
      else
        record = SecurityGroup.new
        record.group_id = member.group_id
      end
      record.name = member.name
      record.description = member.description
      record.ip_permissions = member.ip_permissions
      record.ip_permissions_egress = member.ip_permissions_egress
      record.owner_id = member.owner_id
      record.vpc_id = member.vpc_id
      record.tags = member.tags
      record.save
    end
  end

end
