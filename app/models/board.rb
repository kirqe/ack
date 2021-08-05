# == Schema Information
#
# Table name: boards
#
#  id          :bigint           not null, primary key
#  approved_at :datetime
#  body        :text
#  deleted_at  :datetime
#  name        :string           not null
#  posts_count :integer          default(0)
#  rejected_at :datetime
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_boards_on_slug  (slug) UNIQUE
#
class Board < ApplicationRecord
  include Approvable
  include SoftDeletable

  validates :name,
    presence: true,
    length: { minimum: 3, maximum: 50 }

  validates :slug,
    presence: true,
    uniqueness: true

  validates :body,
    presence: true,
    length: { minimum: 0, maximum: 150 }

  has_many :posts, dependent: :destroy

  scope :ordered_by_post_count, -> { order("posts_count DESC") }
end
