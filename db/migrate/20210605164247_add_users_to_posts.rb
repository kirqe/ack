# frozen_string_literal: true

class AddUsersToPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :posts, :user, null: false, foreign_key: true
  end
end
