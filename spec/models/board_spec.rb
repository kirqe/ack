# == Schema Information
#
# Table name: boards
#
#  id          :bigint           not null, primary key
#  approved_at :datetime
#  body        :text
#  deleted_at  :datetime
#  name        :string           not null
#  posts_count :integer          default(0)
#  rejected_at :datetime
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_boards_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Board, type: :model do
  describe "#valid" do
    it "is invalid when theres no name" do
      board = create(:board)
      board.name = ""
      expect(board).not_to be_valid
    end

    it "is invalid when name is not within (3..50)" do
      board = create(:board)
      board.name = ""
      expect(board).not_to be_valid

      board.name = "11" * 50
      expect(board).not_to be_valid

      board.name = "12345"
      expect(board).to be_valid      
    end    

    it "is invalid when theres no slug" do
      board = create(:board)
      board.slug = ""
      expect(board).not_to be_valid
    end

    it "is invalid when slug is not unique" do
      board1 = create(:board)
      board2 = create(:board)
      board2.slug = board1.slug
      expect(board2).not_to be_valid
    end

    it "is invalid when body is too long (>500)" do
      board = create(:board)
      board.body = "123" * 1000
      expect(board).not_to be_valid
    end
  end
end
