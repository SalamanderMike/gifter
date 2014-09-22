class EventsController < ApplicationController
  before_action :find_user
  before_action :find_user_event, :except => [:index, :new, :create]

  def index
  end

  def new # New Event
    @event = Event.new
  end

  def create # POST: New Event
    event = Event.create(event_params)
    @user.events << event
    redirect_to edit_user_event_path(@user.id, event.id)
  end

  def show # Look over Giftee's Profile
    # Navbar allows "Manage Event Settings"(events/edit)
    # event = Event.find(event_id)
    # jsonObject = event.match[user_id]
    # Top 10 items!
    # Every item is a link to Yelp or Amazon
    # Magic Shopper button

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
