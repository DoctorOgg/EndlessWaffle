class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, index: true
      t.string :environments
      t.timestamps
    end
  end
end
