class EventsController < ApplicationController
  # before_action :find_user
  # before_action :find_user_event, :except => [:index, :new, :create]

  respond_to :json

  def index # JOIN EVENT: Look through all Events to find eventName
    respond_with Event.all
  end

  def index_user_events# Find all Events a user belongs to
    respond_with UsersEvent.where(user_id: session[:id])
  end

  def index_participants
    respond_with UsersEvent.where(event_id: params[:event_id])
  end

  def index_admin_events
    respond_with Event.where(admin_id: session[:id])
  end

  def new # New Event
    @event = Event.new
  end

  def create # POST: New Event

    event = Event.create(event_params)
    @user = User.find_by_id(session[:id])
    @user.events << event
    render json: {}, status: 200

    # redirect_to edit_user_event_path(@user.id, event.id)
  end

  def show
    respond_with Event.find_by_id(params[:id])
  end

  def update # JOIN EVENT
    event = Event.find_by_eventName(params[:id])
    @user = User.find_by_id(session[:id])
    @user.events << event
    render json: {}, status: 200
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
    params.require(:event).permit(:eventName, :password, :admin_id, :participants, :spendingLimit, :match, :expire)
  end
end
