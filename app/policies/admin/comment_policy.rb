# frozen_string_literal: true

module Admin
  class CommentPolicy < Admin::AdminPolicy
    attr_reader :user, :comment

    def initialize(user, comment)
      @user = user
      @comment = comment
      super
    end

    def delete?
      (user.has_role?(:admin) && !comment.user.has_role?(:admin)) || comment.user == user
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
