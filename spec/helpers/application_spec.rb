require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#error_tag(post, field, t = nil)" do
    it "returns only the first error message" do
      post = create(:post)
      post.name = ""
      post.url = "sdf"
      post.save
      span = Nokogiri::HTML(error_tag(post, :name))
      expect(span.text).to eq("Name can't be blank")     
    end

    it "uses a differnet field name if provided" do
      post = create(:post)
      post.name = ""
      post.save
      span = Nokogiri::HTML(error_tag(post, :name, :new_name))
      expect(span.text).to eq("New_name can't be blank")     
    end
  end
end