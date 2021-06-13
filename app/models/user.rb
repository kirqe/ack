# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  ip         :string           not null
#  name       :string
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_token  (token) UNIQUE
#
class User < ApplicationRecord
  before_save :generate_unique_token
  before_save :generate_display_name

  validates :token,
    uniqueness: true

  validates :ip,
    presence: true

  has_many :posts
  has_many :votes

  def voted_for?(votable)
    !votable.votes.find_by(user_id: self).nil?
  end

  private
    def generate_display_name
      adj = Faker::Creature::Bird.silly_adjective
      color = Faker::Creature::Bird.color 
      name = Faker::Creature::Animal.name

      self.name = "#{adj} #{color} #{name}"
    end

    def generate_unique_token
      self.token = loop do
        new_token = SecureRandom.urlsafe_base64(10, false)
        break new_token unless User.exists?(token: new_token)
      end
    end
end
