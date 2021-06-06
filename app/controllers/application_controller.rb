class ApplicationController < ActionController::Base
  helper_method [:current_user, :has_token?]

  def current_user
    @current_user = User.find_by(token: cookies[:token]) if cookies[:token]
  end

  def set_user
    user = User.create(ip: request.remote_ip) #remote_ip
    cookies.permanent[:token] = user.token
    user
  end

  def token_exists?
    !current_user.nil?
  end
end
