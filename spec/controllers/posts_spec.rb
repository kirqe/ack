require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "#pagination" do
    it "shows 20 posts per page" do
      board = create(:board)
      21.times { create(:post, board: board) }
      get board_posts_path(board.slug)
      expect(assigns(:posts).size).to eq(20)
    end
  end
end
