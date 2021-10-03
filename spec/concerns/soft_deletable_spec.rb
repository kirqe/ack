# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SoftDeletable, type: :concern do
  it 'soft deletes/undeletes' do
    post = create(:post)
    expect(post.soft_deleted?).to be_falsey

    post.soft_delete!
    expect(post.soft_deleted?).to be_truthy

    post.restore!
    expect(post.soft_deleted?).to be_falsey
  end

  it 'scopes' do
    create(:post)
    create(:post)
    post1 = create(:post)
    post1.soft_delete!
    create(:post)
    post2 = create(:post)
    post2.soft_delete!
    create(:post)

    expect(Post.soft_deleted.count).to eq(2)
    expect(Post.all.deleted_first.limit(2)).to eq([post1, post2])
  end
end
