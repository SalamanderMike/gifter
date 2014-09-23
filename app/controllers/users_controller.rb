class UsersController < ApplicationController
  before_action :is_authenticated?, :except => [:new, :create]
  before_action :set_user, except: [:new, :create]
  before_action :find_profile, only: [:show, :edit]

  YELP_KEY = ENV["YELP_KEY"]
  YELP_SECRET = ENV["YELP_SECRET"]

  def index
  end

  def new # User Sign-up
    @user = User.new
  end

  def create # POST: New User Sign-up
    user = User.create(user_params)
    session[:id] = user.id
    redirect_to user_path(session[:id])
  end

  def edit # Profile Data WIZARD
    # Guided questions to fill out interests
    # save to arrays along the way
    # save arrays to DB and to object
    # stringify arrays to jsonObject and save to users_events:profile table
  end

  def show # Home Page - show Event Panes, Profile Choice Tag Panes?
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

#find all event ids of current user
    UsersEvent.where(user_id: @user.id).each do |event|
      eachEvent = Event.find_by_id(event.event_id)
      @event_panel.push(eachEvent) #holds each event

      if eachEvent.match
        eachEvent.match.each do |participant|
          if participant[0].to_i == @user.id
            @match = participant[1].to_i
          end
        end
        @matchName = User.find_by_id(@match).firstname
        @eventMatch = Profile.where(user_id: @match)[0]
      end
    end




  end

  def destroy # Deletes user account from database
    current_user.destroy
    session[:id] = nil
    redirect_to login_path
  end


  private

  def set_user
    @user = User.find(session[:id])
    @event_panel = []
    @match = ""
  end

  def find_profile
    @myProfile = Profile.where(user_id: @user.id)
  end

  def user_params
    params.require(:user).permit(:firstName, :lastName, :username, :password)
  end
end
