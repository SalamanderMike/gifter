class ProfileController < ApplicationController
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
end
