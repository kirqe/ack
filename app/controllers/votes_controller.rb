class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    vote = @votable.votes.find_by(user: current_user)

    if vote
      authorize vote
      
      vote.destroy
    else
      vote = @votable.votes.new
      vote.user = current_user

      authorize vote
      vote.save
    end
    
    render json: { votes: @votable.votes_count }      
  end
end