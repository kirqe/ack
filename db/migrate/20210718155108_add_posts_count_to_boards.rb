class AddPostsCountToBoards < ActiveRecord::Migration[6.1]
  def change
    add_column :boards, :posts_count, :integer, default: 0
  end
end
