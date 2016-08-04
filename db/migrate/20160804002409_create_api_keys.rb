class CreateApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :api_keys do |t|
      t.string :access_token, index: true
      t.boolean :admin, :default => false
      t.string :user
      t.timestamps
    end
  end
end
