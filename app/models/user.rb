# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  suspended_till         :datetime
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  include SoftDeletable
  include Suspendable
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  before_validation :normalize_username
  after_create :assign_default_role

  validates :username,
            presence: true,
            uniqueness: true,
            length: { minimum: 3, maximum: 50 }

  has_many :posts
  has_many :votes
  has_many :comments

  def voted_for?(votable)
    !votable.votes.find_by(user_id: self).nil?
  end

  def assign_default_role
    add_role(:member) if roles.blank?
  end

  def username
    soft_deleted? ? '[deleted user]' : read_attribute(:username)
  end

  def active_for_authentication?
    super && !soft_deleted?
  end

  private

  def normalize_username
    self.username = username.to_slug.transliterate.normalize.to_s
  end
end
