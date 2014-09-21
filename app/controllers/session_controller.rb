class SessionController < ApplicationController
  respond_to :json, :html

  def new # login => Authenticate
    @home_page = true
  end

  def create # Authenticate
    @user = User.authenticate(params[:user][:username], params[:user][:password])
    redirect_to login_path if !@user
    session[:id] = @user.id
    redirect_to user_path(session[:id])
  end

  def destroy # Logout
    session[:id] = nil
    redirect_to login_path
  end


private

end
