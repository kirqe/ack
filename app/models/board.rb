# == Schema Information
#
# Table name: boards
#
#  id          :bigint           not null, primary key
#  approved_at :datetime
#  body        :text
#  name        :string           not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_boards_on_slug  (slug) UNIQUE
#
class Board < ApplicationRecord
  validates :name,
    presence: true,
    length: {minimum:3, maximum:50}

  validates :slug,
    presence: true,
    uniqueness: true

  validates :body,
    presence: true,
    length: {minimum:0, maximum:500}

  has_many :posts
end
