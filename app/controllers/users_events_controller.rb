class UsersEventsController < ApplicationController
  respond_to :json

  def index
  end

  def index_user_events# Find all Events a user belongs to
    respond_with UsersEvent.where(user_id: session[:id])
  end

  def index_participants
    respond_with UsersEvent.where(event_id: params[:event_id])
  end

  def update # JOIN EVENT - CREATE LINK
    event = Event.find_by_id(params[:id])
    @user = User.find_by_id(session[:id])
    @user.events << event
    render json: {}, status: 200
  end

  def destroy # ADMIN - Delete User from Event
    respond_with UsersEvent.where(user_id: params[:user_id], event_id: params[:id])
  end

end
