# frozen_string_literal: true

class BoardPolicy < ApplicationPolicy
  attr_reader :user, :board

  def initialize(user, board)
    @user = user
    @board = board
    super
  end

  def index?
    true
  end

  def new?
    true
  end

  def show?
    board.approved? || user&.has_role?(:admin)
  end

  def create?
    true
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user&.has_role?(:admin)
        scope.all
      else
        scope.approved
      end
    end
  end
end
