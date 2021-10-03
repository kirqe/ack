# frozen_string_literal: true

module Admin
  class BoardPolicy < Admin::AdminPolicy
    attr_reader :user, :board

    def initialize(user, board)
      @user = user
      @board = board
      super
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
        scope.all if user&.has_role?(:admin)
      end
    end
  end
end
