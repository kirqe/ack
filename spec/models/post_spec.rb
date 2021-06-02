# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text
#  name       :string           not null
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "#valid?" do
    it "is invalid if name is empty" do
      post = create(:post)

      post.name = ""
      expect(post).not_to be_valid
    end

    it "is invalid if name length is not withing (3..200)" do
      post = create(:post)

      post.name = "name" * 1000
      expect(post).not_to be_valid
      post.name = "na"
      expect(post).not_to be_valid
    end

    it "is invalid if body is empty" do
      post = create(:post)

      post.body = ""
      expect(post).not_to be_valid
    end

    it "is invalid if body length is not withing (3..5000)" do
      post = create(:post)

      post.body = "body" * 1000
      expect(post).to be_valid
      post.body = "na"
      expect(post).not_to be_valid
      post.body = "body" * 2000
      expect(post).not_to be_valid
    end    

    it "is invalid if url has invalid format" do
      post = create(:post)

      post.url = "https://sdf"
      expect(post).to be_valid
      post.url = "https://sdf.com"
      expect(post).to be_valid

      post.url = "https://sfd>.com"
      expect(post).not_to be_valid
    end

  end
end
