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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#valid?" do
    it "is invalid when ..." do
      user = create(:user)
      expect(user).to be_valid
      
      user.username = ""
      expect(user).not_to be_valid      
    end
  end

  describe "#default role" do
    it "has a default role :member on signup" do
      user = create(:user)
      expect(user.has_role?(:member)).to be_truthy
    end
  end

  describe "#user was soft deleted" do
    it "username is no longer shown" do
      post = create(:post)
      post.user.soft_delete!
      expect(post.user.username).to eq("[deleted user]")
    end

    it "user cant sign in" do
      user = create(:user)
      user.soft_delete!
      expect(user.active_for_authentication?).to be_falsy
    end
  end

  describe "#username" do
    it "normalizes username before save" do
      user = create(:user, username: "cinnamon cupcake")
      expect(user.username).to eq("cinnamon-cupcake")

      user1 = build(:user, username:  "cinnaMon, cupcake"   )      
      expect(user1).not_to be_valid
    end
  end
end
