# frozen_string_literal: true

class VotePolicy < ApplicationPolicy
  attr_reader :user, :vote

  def initialize(user, vote)
    @user = user
    @vote = vote
    super
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
      scope.all if user&.has_role?(:admin)
    end
  end
end
