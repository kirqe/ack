class ApplicationController < ActionController::Base
  include Pundit
  include Pagy::Backend
  include ExceptionsRedirect

  layout :set_layout
  before_action :configure_devise_params, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    flash.notice = "Sorry! Couldn't find that page. Bummer."
    redirect_to root_path
  end

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

    def user_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore
      notice = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default

      if request.format.json? 
        render json: { notice: notice }, status: :forbidden
      else
        flash[:notice] = notice
        redirect_to(request.referrer || root_path)
      end
    end
end
