class ProfileController < ApplicationController
  # before_action :find_match_profile, only: [:show]

  respond_to :json, :html

  def index # Show Matched Profile
    render json: Profile.find_by_user_id(params[:user_id])
  end

  def new
  end

  def create
  end

  def show # Show User's Profile
    render json: Profile.find_by_user_id(session[:id])
    # Navbar allows "Manage Event Settings"(events/edit)
    # Top 10 items!
    # Every item is a link to Yelp or Amazon
    # Magic Shopper button
  end

  def update # Add tags to profile DB
    render json: Profile.find_by_user_id(session[:id]).update(profile_params)
  end

  def destroy
    render json: Profile.destroy
  end

private

  def profile_params
    params.require(:profile).permit({cuisine: []}, {shops: []}, {services: []}, {bookGenre: []}, {musicGenre: []}, {clothes: []}, {animal: []}, {metal: []}, {element: []}, {services: []}, {art: []}, {hobbies: []}, {color: []}, :zip)
  end

  def find_match_profile
    id = params[:id]
    @profile = Profile.find_by_id(id)
    @profileName = User.where(id: @profile.user_id)[0].firstname
    # redirect_to user_events_path(@user.id) unless @event
  end
end
