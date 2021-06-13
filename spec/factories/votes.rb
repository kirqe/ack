# == Schema Information
#
# Table name: votes
#
#  id           :bigint           not null, primary key
#  votable_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  votable_id   :bigint           not null
#
# Indexes
#
#  index_votes_on_user_id                 (user_id)
#  index_votes_on_user_id_and_votable_id  (user_id,votable_id) UNIQUE
#  index_votes_on_votable                 (votable_type,votable_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :vote do
    user { create(:user) }
    voted { false }
    votable { create(:post) }
  end
end
