class SessionController < ApplicationController
  def index
    render :new
  end

  def new # login
    @home_page = true
  end

  def create
    # Authenticate
    @user = User.authenticate(params[:user][:username], params[:user][:password])
    if @user
      session[:id] = @user.id
      redirect_to user_path(session[:id])
    else
    redirect_to login_path
    end
  end

  def destroy
    # Logout
    session[:id] = nil
    redirect_to login_path
  end
end
