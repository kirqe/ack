class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def index?
    true
  end

  def show?    
    (post.board.approved? && post.published? && !post.soft_deleted?) || (user && user.has_role?(:admin))
  end

  def create?
    post.board.approved? && user && !user.suspended?
  end

  def update?
    user.has_role?(:admin) || !post.published?
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
      else
        scope.published
      end
    end
  end  
end