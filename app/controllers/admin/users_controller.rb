# frozen_string_literal: true

module Admin
  class UsersController < Admin::AdminController
    before_action :set_user

    def suspend
      if @user.suspended?
        @user.resume!
        flash[:notice] = "User #{@user.username} was successfully resumed"
      else
        if params[:ban]
          @user.suspend!(36_500)
        else
          @user.suspend!
        end

        flash[:notice] = "User #{@user.username} was successfully suspended"
      end

      redirect_back fallback_location: root_path
    end

    def set_user
      @user = User.find(params[:id])
      authorize([:admin, @user])
    end
  end
end
