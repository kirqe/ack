class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :token, null: false
      t.string :ip, null: false

      t.timestamps
    end
    
    add_index :users, :token, unique: true
  end
end
