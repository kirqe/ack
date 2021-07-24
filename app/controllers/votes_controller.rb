class VotesController < ApplicationController
  before_action :authenticate_user!

  def vote
    @votable.votes.find_by(user: current_user).nil? ? 
      cast_vote : revoke_vote

    render json: { votes: @votable.votes_count }
  end

  private
    def cast_vote
      vote = @votable.votes.new
      vote.user = current_user
      vote.save
    end

    def revoke_vote
      @votable.votes.find_by(user: current_user).destroy
    end
end
