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
class Comment < ApplicationRecord
  include SoftDeletable
  belongs_to :user
  before_save :set_depth
  after_create :bump_or_lock_commentable

  has_many_attached :files

  validates :body, 
    presence: true, 
    length: { 
      minimum: 3, 
      maximum: 5000, 
      too_short: "is too short",
      too_long: "is too long"
    }

  validates :files, limit: { max: 4 }
  
  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count
  belongs_to :parent, class_name: "Comment", foreign_key: 'parent_id', optional: true, touch: true
  # has_many :comments, inverse_of: 'parent'
  # has_many :comments, as: :commentable, dependent: :destroy
  has_many :replies, class_name: "Comment", inverse_of: 'parent', foreign_key: 'parent_id', dependent: :destroy 

  scope :root_comments, -> { where(parent: nil, depth: 1) }
  scope :replies_of, -> (comment) { where(parent: comment) }

  def body
    self.soft_deleted? ? "[this comment was deleted]" : read_attribute(:body)
  end

  private
    def set_depth
      self.depth = (parent.depth + 1) if parent
    end

    def bump_or_lock_commentable
      if self.updated_at < Post::LOCK_AFTER.ago
        self.commentable.lock!
      else
        self.commentable.touch
      end      
    end
end
