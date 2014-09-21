class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def is_authenticated?
    redirect_to root_path if session[:user_id].nil? #IS ROOT_PATH CORRECT?***
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if !@current_user
  end
end
