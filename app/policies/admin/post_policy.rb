class Admin::PostPolicy < Admin::AdminPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def pin?
    user.has_role?(:admin)
  end
  
  def lock?
    user.has_role?(:admin)
  end

  def publish?
    user.has_role?(:admin)
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