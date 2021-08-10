require 'rails_helper'

RSpec.describe Pinnable, type: :concern do
  it "pins/unpins" do
    post = create(:post)
    expect(post.pinned?).to be_falsey

    post.pin!
    expect(post.pinned?).to be_truthy

    post.unpin!
    expect(post.pinned?).to be_falsey
  end

  it "scopes" do
    create(:post)    
    create(:post)
    post1 = create(:post)
    post1.pin!
    create(:post)
    post2 = create(:post)
    post2.pin!
    create(:post)

    expect(Post.pinned.count).to eq(2)
    expect(Post.all.pinned_first.limit(2)).to eq([post1, post2])
  end
end