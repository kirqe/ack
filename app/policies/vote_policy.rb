class VotePolicy < ApplicationPolicy
  attr_reader :user, :vote

  def initialize(user, vote)
    @user = user
    @vote = vote
  end

  def create?
    !@vote.votable.locked?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user && user.has_role?(:admin)
        scope.all
      end
    end
  end
end