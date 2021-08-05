class Admin::CommentPolicy < Admin::AdminPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def delete?
    user.has_role?(:admin) && !comment.user.has_role?(:admin)
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