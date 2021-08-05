class Admin::UserPolicy < Admin::AdminPolicy
  attr_reader :user, :subject

  def initialize(user, subject)
    @user = user
    @subject = subject
  end

  def suspend?
    user.has_role?(:admin) && !subject.has_role?(:admin)
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