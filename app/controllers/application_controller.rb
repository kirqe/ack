class ApplicationController < ActionController::Base
  include Pagy::Backend
  # helper_method [:current_user, :has_token?]
  # before_action :current_user

  layout :set_layout
  before_action :configure_devise_params, if: :devise_controller?

  private
    def set_layout
      devise_controller? ? "auth" : "application"
    end

    def configure_devise_params
      keys = [
        :username,
        :email,
        :password,
        :password_confirmation
      ]
      devise_parameter_sanitizer.permit(:sign_up, keys: keys)
      devise_parameter_sanitizer.permit(:account_update, keys: keys)
    end
end
