class CreateAmis < ActiveRecord::Migration[5.0]
  def change
    create_table :amis do |t|
      t.string :availability_zone, index: true
      t.string :name, index: true
      t.string :version, index: true
      t.string :arch
      t.string :instance_type
      t.integer :release
      t.string :ami_id,  index: true
      t.string :aki_id,  index: true
      t.timestamps
    end
  end
end
