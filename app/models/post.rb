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
    format: { with: URI::DEFAULT_PARSER.regexp[:ABS_URI] }

  validates :body,
    length: { minimum:3, maximum: 5000}
end
