# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  body           :text
#  comments_count :integer          default(0)
#  deleted_at     :datetime
#  locked_at      :datetime
#  name           :string           not null
#  pinned_at      :datetime
#  published_at   :datetime
#  slug           :string
#  url            :string
#  votes_count    :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  board_id       :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_board_id  (board_id)
#  index_posts_on_slug      (slug) UNIQUE
#  index_posts_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (board_id => boards.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :post do
    name { Faker::Name.name }
    url { Faker::Internet.url }
    body { Faker::Lorem.paragraph(sentence_count: 3) }
    user { create(:user) }
    board { create(:board) }
  end
end
