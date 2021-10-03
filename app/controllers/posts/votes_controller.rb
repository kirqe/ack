# frozen_string_literal: true

module Posts
  class VotesController < ::VotesController
    before_action :set_votable

    private

    def set_votable
      @votable = Post.friendly.find(params[:post_id])
    end
  end
end
