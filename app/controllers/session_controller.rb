class SessionController < ApplicationController
  respond_to :json, :html

  def new # login => Authenticate
    if session[:id]
      redirect_to site_index_path
    else
      render :new
    end
  end

  def create # Authenticate
    @user = User.authenticate(params[:user][:email], params[:user][:password])
    if @user
      session[:id] = @user.id
      gon.global.sessionID = session[:id]
      redirect_to site_index_path
    else
      render :new
    end
  end

  def destroy # Logout
    session[:id] = nil
    gon.global.sessionID = nil
    respond_to do |f|
      f.json { render json: {}}
    end
  end

  def authorized
    if session[:id]
      gon.global.sessionID = session[:id]
      render json: User.find_by_id(session[:id]), only: [:id, :email]
    else
      render json: {}, status: 401
    end
  end
end
