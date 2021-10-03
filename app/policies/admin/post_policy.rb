# frozen_string_literal: true

module Admin
  class PostPolicy < Admin::AdminPolicy
    attr_reader :user, :post

    def initialize(user, post)
      @user = user
      @post = post
      super
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
