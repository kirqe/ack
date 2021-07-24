# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  body           :text
#  comments_count :integer          default(0)
#  name           :string           not null
#  slug           :string
#  url            :string
#  votes_count    :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  board_id       :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_board_id  (board_id)
#  index_posts_on_slug      (slug) UNIQUE
#  index_posts_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (board_id => boards.id)
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  before_save :strip_link

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, 
    presence: true,
    length: { 
      minimum:3, 
      maximum: 250, 
      too_short: "is too short", 
      too_long: "is too long" 
    }

  validates :url, 
    presence: true,
    format: { with: URI::DEFAULT_PARSER.regexp[:ABS_URI] },
    allow_blank: true

  validates :body,
    presence: true,
    length: { 
      minimum:10, 
      maximum: 40000, 
      too_short: "is too short",
      too_long: "is too long" 
    },
    allow_blank: true

  belongs_to :user
  belongs_to :board, counter_cache: :posts_count

  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  has_many_attached :files

  scope :newest_first, -> { order("created_at DESC") }
  scope :top_rated, -> { order("votes_count DESC") }
  scope :active, -> { order("updated_at DESC") }
  scope :newest_and_top_rated, -> { top_rated.newest_first }

  def strip_link
    self.url.strip!
  end

  def normalize_friendly_id(text)
    text.to_slug.transliterate.normalize.to_s
  end
  
  def should_generate_new_friendly_id?
    name_changed?
  end    
end
