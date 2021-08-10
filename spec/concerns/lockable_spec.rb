require 'rails_helper'

RSpec.describe Lockable, type: :concern do
  it "locks/unlocks" do
    post = create(:post)
    expect(post.locked?).to be_falsey

    post.lock!
    expect(post.locked?).to be_truthy

    post.unlock!
    expect(post.locked?).to be_falsey
  end

  it "scopes" do
    create(:post)    
    create(:post)
    post1 = create(:post)
    post1.lock!
    create(:post)
    post2 = create(:post)
    post2.lock!
    create(:post)

    expect(Post.locked.count).to eq(2)
    expect(Post.all.locked_first.limit(2)).to eq([post1, post2])
  end
end