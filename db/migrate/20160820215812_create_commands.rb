class CreateCommands < ActiveRecord::Migration[5.0]
  def change
    create_table :commands do |t|
      t.string :name, index: true
      t.text :command
      t.timestamps
    end
  end
end
