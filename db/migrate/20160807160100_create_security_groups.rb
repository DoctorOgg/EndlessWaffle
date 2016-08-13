class CreateSecurityGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :security_groups do |t|
      t.string :name, index: true
      t.string :description
      t.string :group_id, index: true
      t.string :ip_permissions
      t.string :ip_permissions_egress
      t.string :owner_id
      t.string :vpc_id,  index: true
      t.string :tags
      t.timestamps
    end
  end
end
