class Spots::PendingsController < ApplicationController
  def index
    @pending_spots = Spot.where(accepted: nil)
  end
end
