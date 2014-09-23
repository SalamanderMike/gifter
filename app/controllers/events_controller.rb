class EventsController < ApplicationController
  before_action :find_user
  before_action :find_user_event, :except => [:index, :new, :create]


  def index # Show example Settings Manager
  end

  def new # New Event
    @event = Event.new
  end

  def create # POST: New Event
    event = Event.create(event_params)
    @user.events << event
    redirect_to edit_user_event_path(@user.id, event.id)
  end

  def show
  end

  def edit # ADMIN SETTINGS
    # Modal Popup
    # Progress Bar showing participation
    # List of participants who've joined w/delete buttons
    # Text fields to edit number of participants
  end

  def destroy # ADMIN - Delete Event
  end

  private
  # SHUFFLE equation:
  # but use User.where() instead to limit to groups
  # User.all.map(&:id).shuffle.zip(User.all.map(&:id).shuffle)


  def find_user
    user_id = params[:user_id]
    @user = User.find_by_id(user_id)
    # redirect_to users_path unless @user
  end

  def find_user_event
    id = params[:id]
    @event = Event.find_by_id(id)
    # redirect_to user_events_path(@user.id) unless @event
  end

  def event_params
    params.require(:event).permit(:eventName, :groupID, :participants, :spendingLimit, :match, :expire)
  end
end
