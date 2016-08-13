class CreateAmiInstanceTypeMatrices < ActiveRecord::Migration[5.0]
  def change
    create_table :ami_instance_type_matrices do |t|
      t.string :family
      t.integer :virtualization_engine
      t.integer :storage_engine
      t.timestamps
    end
  end
end
