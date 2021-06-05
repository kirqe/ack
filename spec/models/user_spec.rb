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
