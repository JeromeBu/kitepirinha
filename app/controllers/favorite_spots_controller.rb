class FavoriteSpotsController < ApplicationController

  def index
    @favorite_spots = policy_scope(FavoriteSpot).where(user: current_user)
  end

  def create
    @spot = Spot.find(params[:spot_id])
    authorize @spot
    @favorite_spot = FavoriteSpot.new
    @favorite_spot.spot = @spot
    @favorite_spot.user = current_user
    authorize @favorite_spot
    if @favorite_spot.save
      redirect_to favorite_spots_path
    else
      flash[:alert] = "You can't add a post twice to your favorite spots, of course, pffff"
      redirect_to :back
    end
  end

  def destroy
    @favorite_spot = FavoriteSpot.find(params[:id])
    authorize @favorite_spot
    if @favorite_spot.destroy
      redirect_to favorite_spots_path
    else
      redirect_to favorite_spots_path
    end
  end
end
