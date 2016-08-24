class FixNonSupportedEnumPostgresql < ActiveRecord::Migration[5.0]
  def change
    remove_column :ami_instance_type_matrices, :virtualization_engine
    add_column :ami_instance_type_matrices, :virtualization_engine, :string
    remove_column :ami_instance_type_matrices, :storage_engine
    add_column :ami_instance_type_matrices, :storage_engine, :string
    remove_column :provision_job_data, :status
    add_column :provision_job_data, :status, :string
  end
end
