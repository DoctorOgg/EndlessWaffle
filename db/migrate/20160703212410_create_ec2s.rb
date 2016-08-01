class CreateEc2s < ActiveRecord::Migration[5.0]
  def change
    create_table :ec2s do |t|
      t.string :instanceId, index: true
      t.string :ownerId, index: true
      t.string :imageId, index: true
      t.string :keyName
      t.integer :amiLaunchIndex
      t.string :instanceType, index: true
      t.string :kernelId
      t.string :hypervisor
      t.string :architecture
      t.boolean :sourceDestCheck
      t.string :clientToken
      t.text :networkInterfaces
      t.text :placement
      t.text :iamInstanceProfile
      t.text :instanceState
      t.text :monitoring
      t.text :productCodes
      t.text :stateReason
      t.text :tagSet
      t.text :blockDeviceMapping
      t.string :privateDnsName, index: true
      t.string :dnsName, index: true
      t.string :subnetId
      t.string :vpcId
      t.string :privateIpAddress, index: true
      t.string :ipAddress, index: true
      t.string :rootDeviceType
      t.string :rootDeviceName
      t.string :virtualizationType
      t.string :networkInterfaceId
      t.string :attachmentId
      t.string :ebsOptimized
      t.datetime :launchTime
      t.string :reason, index: true
      t.integer :nodemap_id, index: true
      t.timestamps
    end
  end
end
