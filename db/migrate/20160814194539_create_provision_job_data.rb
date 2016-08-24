class CreateProvisionJobData < ActiveRecord::Migration[5.0]
  def change
    create_table :provision_job_data do |t|
      t.integer :status
      t.string :arguments
      t.string :environment
      t.string :role
      t.string :name
      t.text :log
      t.timestamps
    end
  end
end
