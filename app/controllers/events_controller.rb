class EventsController < ApplicationController
  respond_to :json

  def index # JOIN EVENT: Look through all Events to find eventName
    respond_with Event.all
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
  end

  def show
    respond_with Event.find_by_id(params[:id])
  end

  def update # UPDATE EVENT PARAMS
    respond_with Event.find_by_id(params[:id]).update(event_params)
  end


  private
  def event_params
    params.require(:event).permit(:eventName, :password, :admin_id, :participants, :spendingLimit, :match, :expire)
  end
end
