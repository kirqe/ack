# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text             not null
#  commentable_type :string           not null
#  deleted_at       :datetime
#  depth            :integer          default(1), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint           not null
#  parent_id        :bigint
#  user_id          :bigint           not null
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#  index_comments_on_parent_id    (parent_id)
#  index_comments_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#valid?' do
    it 'valid?' do
      post = create(:post)
      comment = create(:comment, commentable: post)
      expect(comment).to be_valid

      comment.body = ''
      expect(comment).not_to be_valid

      comment.body = 'a' * 5001
      expect(comment).not_to be_valid

      comment.body = 'a' * 5000
      expect(comment).to be_valid
    end
  end

  describe '#assoc' do
    it 'works' do
      post = create(:post)

      create(:comment, commentable: post)
      create(:comment, commentable: post)

      expect(post.comments_count).to eq(2)
    end
  end

  describe 'depth, parent, replies' do
    it 'increments depth on reply' do
      post = create(:post)
      comment = create(:comment, commentable: post)
      expect(comment.parent_id).to be_falsy

      comment1 = create(:comment, commentable: post, parent: comment)
      expect(comment1.parent).to eq(comment)
      expect(comment1.depth).to eq(2)

      comment2 = create(:comment, commentable: post, parent: comment)
      expect(comment.replies.count).to eq(2)

      comment3 = create(:comment, commentable: post, parent: comment2)
      expect(comment3.depth).to eq(3)
    end
  end

  describe 'soft deleting' do
    it 'works' do
      post = create(:post)
      comment = create(:comment, commentable: post)
      comment.soft_delete!
      expect(comment.body).to eq('[this comment was deleted]')
    end
  end

  describe 'commebtable bumping' do
    it 'touches commentable on action' do
      post = create(:post)
      comment = create(:comment, commentable: post)

      expect(post.updated_at.utc.to_s).to eq(comment.created_at.utc.to_s)

      comment1 = create(:comment, commentable: post, parent: comment)
      expect(post.updated_at.utc.to_s).to eq(comment1.created_at.utc.to_s)
      expect(post.board.updated_at.utc.to_s).to eq(comment.created_at.utc.to_s)
    end
  end

  describe 'attaching files' do
    it 'can attach 4 files' do
      post = create(:post)
      comment = create(:comment, commentable: post)

      comment.files.attach(
        io: File.open(Rails.root.join('app', 'assets', 'images', 'logo.png')),
        filename: 'logo.png'
      )
      comment.save
      expect(comment).to be_valid

      5.times do
        comment.files.attach(
          io: File.open(Rails.root.join('app', 'assets', 'images', 'logo.png')),
          filename: 'logo.png'
        )
      end
      comment.save

      expect(comment).not_to be_valid
    end
  end
end
