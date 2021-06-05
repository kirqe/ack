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
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    ip { Faker::Internet.ip_v4_address }
  end
end
