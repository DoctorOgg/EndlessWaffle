class Addjobid < ActiveRecord::Migration[5.0]
  def change
    add_column :provision_job_data, :uuid, :string
  end
end
