class UsersController < ApplicationController
  before_action :is_authenticated?, :except => [:new, :create]
  before_action :set_user, except: [:new, :create]

  YELP_KEY = ENV["YELP_KEY"]
  YELP_SECRET = ENV["YELP_SECRET"]

  def index
  end

  def new # User Sign-up
    @user = User.new
  end

  def create # POST for new User Sign-up
    user = User.create(user_params)
    session[:id] = user.id
    redirect_to user_path(session[:id])
  end

  def edit # Fill out profile data
  end

  def show # Home Page
  end

  def destroy # Deletes user from database
    current_user.destroy
    session[:id] = nil
    redirect_to login_path
  end


  private

  def set_user
    @user = User.find(session[:id])
  end

  def user_params
    params.require(:user).permit(:firstName, :lastName, :username, :password)
  end
end
