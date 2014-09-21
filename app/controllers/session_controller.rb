class SessionController < ApplicationController
  def index
    render :new
  end

  def new
    @home_page = true
    #login
  end

  def create
    # Authenticate
    puts "HELLO!"

    @user = User.authenticate(params[:user][:username], params[:user][:password])
    puts @user.inspect
    if @user
      puts @user.inspect
      session[:id] = @user.id
      redirect_to user_path # ADJUST PATH AS NEEDED
    else
    redirect_to login_path
    end
  end

  def destroy
    # Logout
    session[:user_id] = nil
    redirect_to login_path
  end
end
