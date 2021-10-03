# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe '#pagination' do
    it 'shows 20 posts per page' do
      board = create(:board)
      25.times { create(:post, board: board) }
      get :index, params: { board_id: board.slug }
      expect(assigns(:posts).size).to eq(20)

      get :index, params: { board_id: board.slug, page: 2 }
      expect(assigns(:posts).size).to eq(5)
    end
  end
end
