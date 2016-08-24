class CreateBuildlogs < ActiveRecord::Migration[5.0]
  def change
    create_table :buildlogs do |t|
      t.string :uuid, index: true
      t.text :log
      t.timestamps
    end
  end
end
