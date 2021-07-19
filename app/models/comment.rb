# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text             not null
#  commentable_type :string           not null
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
  belongs_to :user
  before_save :set_depth

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
  belongs_to :parent, class_name: "Comment", foreign_key: 'parent_id', optional: true
  # has_many :comments, inverse_of: 'parent'
  # has_many :comments, as: :commentable, dependent: :destroy
  has_many :replies, class_name: "Comment", inverse_of: 'parent', foreign_key: 'parent_id', dependent: :destroy 

  # collapse comments at this depth
  DEPTH = 2
  
  scope :root_comments, -> { where(parent: nil, depth: 1) }
  scope :replies_of, -> (comment) { where(parent: comment) }

  private
    def set_depth
      self.depth = (parent.depth + 1) if parent
    end
end
