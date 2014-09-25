class GifterTemplatesController < ApplicationController
  before_action :find_my_info
  layout false

  def index
  end


  def user_records
    render json: User.find(session[:id])
  end

  def event_records
    render json: @myEvents
  end

  def profile_records
    render json: Profile.all
  end

  def user_to_events_records
    render json: @myEventIDs
  end

private

  def find_my_info
    @myEventIDs = UsersEvent.where(user_id: session[:id])
    @myEvents = []
    @myMatch = []
    @matchInEvent = []

    @myEventIDs.each do |event|
      eachEvent = (Event.find_by_id(event.event_id))
        @myEvents.push(eachEvent)
      end


    # @myEvents.each do |event|
    #   matchInEvent.push(event.id, )
    # end

  end

end
