# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  body           :text
#  comments_count :integer          default(0)
#  name           :string           not null
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
    name { "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis n
ostrud exercitation ullamco laboris nisi utt" }
    url { "https://url-#{SecureRandom.hex(4)}.com" }
    body { "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." }
    user { create(:user) }
  end
end
