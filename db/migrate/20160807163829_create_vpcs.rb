class CreateVpcs < ActiveRecord::Migration[5.0]
  def change
    create_table :vpcs do |t|
      t.string :vpc_id, index: true
      t.string :state
      t.string :cidr_block
      t.string :dhcp_options_id
      t.string :tags
      t.string :tenancy
      t.timestamps
    end
  end
end
