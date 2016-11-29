class SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :edit, :update]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @spots = policy_scope(Spot)
  end

  def show
  end

  def new
    @spot = current_user.spots.new
    authorize @spot
  end

  def create
    @spot = Spot.new(spot_params)
    a = ArtisanalGeocoder.geo(spot_params[:name])
    @spot.user= current_user
    @spot.lat = a[:lat]
    @spot.lng = a[:lng]
    @spot.harbor = Harbor.first
    authorize @spot

    if @spot.save
      redirect_to spot_path(@spot)
    else
      render :new
    end

  end

  def edit
  end

  def update
    @spot.update(spot_params)
    if @spot.save
      redirect_to spot_path(@spot)
    else
      render :edit
    end
  end

  def destroy
    @spot.destroy
    redirect_to spots_path
  end

  private

  def set_spot
    @spot = Spot.find(params[:id])
    authorize @spot
  end

  def spot_params
    params.require(:spot).permit(:name, :description, :latitude, :longitude)
  end
end
