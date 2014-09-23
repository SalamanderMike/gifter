class ProfileController < ApplicationController
  before_action :find_match_profile, only: [:show]


  def index
  end

  def show # Show Matched Profile








    # UsersEvent.where(user_id: @user.id).each do |event|
    #   eachEvent = Event.find_by_id(event.event_id)
    #   @event_panel.push(eachEvent) #holds each event

    #   if eachEvent.match
    #     eachEvent.match.each do |participant|
    #       if participant[0].to_i == @user.id
    #         @match = participant[1].to_i
    #       end
    #     end
    #     @matchName = User.find_by_id(@match).firstname
    #     @eventMatch = Profile.where(user_id: @match)[0]
    #   end
    # end

  end

private

  def find_match_profile
    id = params[:id]
    @profile = Profile.find_by_id(id)
    @profileName = User.where(id: @profile.user_id)[0].firstname
    # redirect_to user_events_path(@user.id) unless @event
  end



end
