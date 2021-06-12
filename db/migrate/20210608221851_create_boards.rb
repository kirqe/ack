class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :body
      t.datetime :approved_at

      t.timestamps
    end
    add_index :boards, :slug, unique: true    
  end
end
