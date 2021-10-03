# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Publishable, type: :concern do
  it 'publish/unpublish' do
    post = create(:post)
    expect(post.published?).to be_truthy

    post.unpublish!
    expect(post.published?).to be_falsey
    expect(post.hidden?).to be_truthy

    post.publish!
    expect(post.published?).to be_truthy
  end

  it 'scopes' do
    create(:post)
    create(:post)
    create(:post).unpublish!
    create(:post)
    create(:post).unpublish!
    create(:post)

    expect(Post.hidden.count).to eq(2)
    expect(Post.published.count).to eq(4)
  end
end
