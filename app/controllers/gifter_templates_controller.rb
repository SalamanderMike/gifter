class GifterTemplatesController < ApplicationController
  before_action :find_my_info
  layout false

  def index
  end


  def user_records
    render json: User.find(session[:id])
  end

  def user_update
    puts @user
    render json: @user.update(user_params)
  end

  def event_records
    render json: @myEvents
  end

  def profile_records
    render json: Profile.all
  end

  def profile_create
    render json: @userProfile.create(profile_params)
  end

  def user_to_events_records
    render json: @myEventIDs
  end

private

  def find_my_info

    @user = User.find(session[:id])
    @userProfile = Profile.find_by_user_id(session[:id])


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

  def profile_params
    params.require(:profile).permit(:cuisine, :shops, :services, :bookGenre, :musicGenre, :clothes, :animal, :metal, :element, :services, :art, :hobbies)
  end

 def user_params
    params.require(:user).permit(:firstname, :lastname)
  end

end
