require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "#pagination" do
    it "shows 20 posts per page" do
      21.times { create(:post) }
      get :index
      expect(assigns(:posts).size).to eq(20)
    end
  end
end
