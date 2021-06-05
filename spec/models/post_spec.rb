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

    it "is invalid based on presence of the fields" do
      post = create(:post)
      post.name = ""
      post.url = ""
      post.body = ""
      expect(post).not_to be_valid

      post.name = "123123123"
      post.url = ""
      post.body = ""
      expect(post).to be_valid

      post.name = ""
      post.url = "123123123"
      post.body = ""
      expect(post).not_to be_valid

      post.name = ""
      post.url = ""
      post.body = "123123123"
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

  describe "scopes" do
    it "#shows newest posts in the first place" do
      post1 = create(:post)
      post2 = create(:post)
      post3 = create(:post)

      expect(Post.newest_first).to eq([post3, post2, post1])
    end
  end
  
end