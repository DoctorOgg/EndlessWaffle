class CreateSubnets < ActiveRecord::Migration[5.0]
  def change
    create_table :subnets do |t|
      t.string :subnet_id, index: true
      t.string :state
      t.string :vpc_id, index: true
      t.string :cidr_block
      t.integer :available_ip_address_count
      t.string :availability_zone, index: true
      t.string :tag_set
      t.boolean :map_public_ip_on_launch
      t.timestamps
    end
  end
end
