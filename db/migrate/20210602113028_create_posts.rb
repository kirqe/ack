# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :name, null: false
      t.string :url
      t.text :body
      t.string :slug

      t.datetime :published_at
      t.datetime :deleted_at
      t.datetime :pinned_at
      t.datetime :locked_at

      t.integer :comments_count, default: 0
      t.integer :votes_count, default: 0

      t.timestamps
    end

    add_index :posts, :slug, unique: true
  end
end
