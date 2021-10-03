# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.integer :depth, null: false, default: 1
      t.references :parent, index: true
      t.references :commentable, polymorphic: true, null: false

      t.datetime :deleted_at

      t.timestamps
    end
  end
end
