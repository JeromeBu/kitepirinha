class SpotsController < ApplicationController

  before_action :set_spot, only: [:show, :edit, :update]
  skip_before_action :authenticate_user!, only: :index

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
    @spot = current_user.spots.new(spot_params)
    authorize @spot

    @spot.save ? redirect_to @spot : render :new
  end

  def edit
  end

  def update
    @spot.update(spot_params)
    @spot.save ? redirect_to @spot : render :new
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
    require.params(:spot).permit(:description, :lat, :lng, :user_id)
  end
end
