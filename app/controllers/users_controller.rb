class UsersController < ApplicationController
  before_action :is_authenticated?, :except => [:new, :create]

  YELP_KEY = ENV["YELP_KEY"]
  YELP_SECRET = ENV["YELP_SECRET"]

  def index
  end

  def new # User Sign-up
    @user = User.new
  end

  def create # POST for new User Sign-up
    user = User.create(user_params)
    session[:user_id] = user.id
    redirect_to user_path(user.id)
  end

  def edit # Fill out profile data
    @user = current_user
    render :edit
  end

  def show # Home Page
    @current_user = current_user
    @user = User.find_by_id(params[:id])
  end

  def destroy #Logout?? or session#destroy?
    current_user.destroy
    redirect_to root_path
  end


  private

  def user_params
    params.require(:user).permit(:firstName, :lastName, :username, :password)
  end
end
