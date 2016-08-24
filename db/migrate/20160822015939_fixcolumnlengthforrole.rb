class Fixcolumnlengthforrole < ActiveRecord::Migration[5.0]
  def change
    remove_column :roles, :environments
    add_column :roles, :environments, :text
  end
end
