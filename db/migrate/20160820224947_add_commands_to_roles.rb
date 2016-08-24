class AddCommandsToRoles < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :provision_command, :string
    add_column :roles, :terminate_command, :string
  end
end
