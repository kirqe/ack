# == Schema Information
#
# Table name: boards
#
#  id          :bigint           not null, primary key
#  approved_at :datetime
#  body        :text
#  deleted_at  :datetime
#  name        :string           not null
#  posts_count :integer          default(0)
#  rejected_at :datetime
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_boards_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :board do
    name { Faker::Name.name }
    slug { Faker::Name.name.downcase }
    body { "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." }
    approved_at { nil }
  end
end
