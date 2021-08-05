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
class Vote < ApplicationRecord
  after_create :bump_or_lock_votable

  belongs_to :user
  belongs_to :votable, polymorphic: true, counter_cache: :votes_count

  private
  def bump_or_lock_votable
    if self.updated_at < Post::LOCK_AFTER.ago
      self.votable.lock!
    else
      self.votable.touch
    end      
  end
end
