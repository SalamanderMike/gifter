class ProfileController < ApplicationController
  before_action :find_match_profile, only: [:show]

  def index # Example profile for general public
  end

  def show # Show Matched Profile
    # Navbar allows "Manage Event Settings"(events/edit)
    # Top 10 items!
    # Every item is a link to Yelp or Amazon
    # Magic Shopper button
  end

private

  def find_match_profile
    id = params[:id]
    @profile = Profile.find_by_id(id)
    @profileName = User.where(id: @profile.user_id)[0].firstname
    # redirect_to user_events_path(@user.id) unless @event
  end
end