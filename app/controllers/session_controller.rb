class SessionController < ApplicationController
  before_action :logout_check
  before_action :login_check
  before_action :render_main_layout_if_format_html, only: [:new]
  respond_to :json, :html

  def new # login => Authenticate
    respond_with (@home_page = true)
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
    session[:id] = nil
    redirect_to login_path
  end


private

  def render_main_layout_if_format_html
    if request.format.symbol == :html
      render "/session/new"
    end
  end

  def login_check
    if session[:id]
      gon.global.sessionID = session[:id]
      redirect_to user_path(session[:id])
    end
  end



  def logout_check #NOT WORKING YET
    # if gon.global.sessionID = {}#can't set from GifterController
    #   session[:id] = nil
    # end
    # test = session[:id]
    # puts test
  end
end
