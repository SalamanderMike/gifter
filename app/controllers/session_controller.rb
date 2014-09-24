class SessionController < ApplicationController


  respond_to :json, :html

  def new # login => Authenticate
    puts session[:id]
    if session[:id]
      redirect_to user_path(session[:id])
    else
      render :new
    end
  end

  def create # Authenticate
    @user = User.authenticate(params[:user][:email], params[:user][:password])
    if @user
      session[:id] = @user.id
      gon.global.sessionID = session[:id]
      redirect_to user_path(session[:id])
    else
      render :new
    end
  end

  def destroy # Logout
    puts "destroying"
    session[:id] = nil
    gon.global.sessionID = nil
    p session
    respond_to do |f|
      f.json { render json: {}}
    end
  end

  def login_check
    if session[:id]
      gon.global.sessionID = session[:id]
      render json: User.find_by_id(session[:id]), only: [:id, :email]
    else
      render json: {}, status: 401
    end
  end

end
