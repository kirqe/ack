# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text
#  name       :string           not null
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  validates :name, 
    presence: true,
    length: { minimum:3, maximum: 200 }

  validates :url, 
    presence: true,
    format: { with: URI::DEFAULT_PARSER.regexp[:ABS_URI] },
    allow_blank: true

  validates :body,
    presence: true,
    length: { minimum:3, maximum: 5000},
    allow_blank: true


  scope :newest_first, -> { order("created_at DESC") }
end
