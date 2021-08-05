class Admin::BoardPolicy < Admin::AdminPolicy
  attr_reader :user, :board

  def initialize(user, board)
    @user = user
    @board = board
  end

  def approve?
    user.has_role?(:admin)
  end

  def reject?
    user.has_role?(:admin)
  end
  
  def delete?
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