class UsersController < ApplicationController
  # before_action :render_main_layout_if_format_html, only: [:new, :create]
  before_action :is_authenticated?, except: [:new, :create]

  respond_to :json, :html

  YELP_KEY = ENV["YELP_KEY"]
  YELP_SECRET = ENV["YELP_SECRET"]

  def index
    render json: User.find(session[:id])
  end

  def new # User Sign-up
    @user = User.new
  end

  def create # POST: New User Sign-up
    user = User.create(user_params)
    session[:id] = user.id
    Profile.create(user_id:session[:id])
    redirect_to site_index_path
  end

  def show # ???
    render json: User.find(params[:id])
  end

  def update # Profile Data WIZARD ***TO BE IMPLEMENTED***
    respond_with User.find(session[:id]).update(user_params)
  end

  def destroy # Deletes user account from database
    current_user.destroy
    session[:id] = nil
    redirect_to login_path
  end

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password)
  end

  # def render_main_layout_if_format_html
  #   if request.format.symbol == :html
  #     render "users/new"
  #   end
  # end
end



