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

RSpec.describe PostsHelper, type: :helper do
  describe "#post_link(post)" do
    it "returns post.url if url was provided" do
      post = create(:post)
      link = Nokogiri::HTML(post_link(post))
      expect(link.css('a').first["href"]).to eq(post.url)
    end

    it "returns post_path if url was not" do
      post = create(:post)
      post.url = ""
      link = Nokogiri::HTML(post_link(post))
      expect(link.css("a").first["href"]).to eq(post_path(post))
    end
  end

  describe "#error_tag(post, field, t = nil)" do
    it "returns only the first error message" do
      post = create(:post)
      post.name = ""
      post.url = "sdf"
      post.save
      span = Nokogiri::HTML(error_tag(post, :name))
      expect(span.text).to eq("name can't be blank")     
    end
    it "uses a differnet field name if provided" do
      post = create(:post)
      post.name = ""
      post.save
      span = Nokogiri::HTML(error_tag(post, :name, :new_name))
      expect(span.text).to eq("new_name can't be blank")     
    end
  end
end
