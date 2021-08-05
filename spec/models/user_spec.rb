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
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#valid?" do
    it "is invalid when there's no ip or token" do
      user = create(:user)
      expect(user).to be_valid
      
      user.ip = ""
      expect(user).not_to be_valid
    end

    it "is invalid when token is not unique" do
      user1 = create(:user)
      user2 = create(:user)

      user2.token = user1.token
      expect(user2).not_to be_valid
    end
  end

  describe "#effects" do
    it "generates user token before saving it" do
      user = User.new(name: "john", ip: Faker::Internet.ip_v4_address)
      user.save
      
      expect(user).to be_valid
      expect(User.all.count).to eq(1)
    end

    it "generates a display name" do
      user = User.new(name: "john", ip: Faker::Internet.ip_v4_address)
      user.save
      
      expect(user.name).not_to be_empty
    end
  end
  
end
