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
    body { Faker::Lorem.sentence(word_count: 3) }
    approved_at { nil }
  end
end
