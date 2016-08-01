class CreateNodemaps < ActiveRecord::Migration[5.0]
  def change
    create_table :nodemaps do |t|
      t.string :role
      t.string :environment
      t.string :name
      t.string :instanceState
      t.timestamps
    end
  end
end
