# frozen_string_literal: true

module Admin
  class UserPolicy < Admin::AdminPolicy
    attr_reader :user, :subject

    def initialize(user, subject)
      @user = user
      @subject = subject
      super
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
        scope.all if user&.has_role?(:admin)
      end
    end
  end
end
