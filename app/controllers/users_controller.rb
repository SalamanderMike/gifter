class UsersController < ApplicationController
  # before_action :render_main_layout_if_format_html, only: [:new, :create]
  before_action :is_authenticated?, except: [:new, :create]
  # before_action :set_user, except: [:new, :create]
  # before_action :find_profile, only: [:show, :edit]
  # before_action :set_up_event_panels, only: [:show, :edit]

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

  def show # Home Page - show Event Panes, Profile Choice Tag Panes?
    render json: User.find(params[:id])
    # Event Panels - Users_event.all where user_id == session[:id]**
    #   EventName, Ready/Complete indicator, Magic Buy button
    #   event = Event.find(event_id)**
    #   if event.match != nil then iterate through user_ids to find match
    #   onClick redirect_to /events/show - Event.find(event_id)
    # Join Event button
    #   to where?
    # Interests Panels
    #   linkedIn style editable tags w/autocomplete
    #   Iterate through user DB
    #   save arrays to user DB and jsonObject to users_events:profile DB on each submit
  end

  def update # Profile Data WIZARD
    respond_with User.find(session[:id]).update(user_params)


    # Guided questions to fill out interests
    # save to arrays along the way
    # save arrays to DB and to object
    # stringify arrays to jsonObject and save to users_events:profile table
  end

  def destroy # Deletes user account from database
    current_user.destroy
    session[:id] = nil
    redirect_to login_path
  end


  private

  # def profile_init
  #   user_id = session[:id]
  #   params = ActionController::Parameters.new({:user_id => session[:id], :cuisine => []})
  #   params.permit(:user_id, :cuisine => ["Wine")
  # end

  def render_main_layout_if_format_html
    if request.format.symbol == :html
      render "users/new"
    end
  end

  def set_user
    @user = User.find(session[:id])
    @event_panel = []
    @match = []
    @matchReady = "NOT READY"
  end

  def find_profile
    @myProfile = Profile.where(user_id: @user.id)
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password)
  end
end



