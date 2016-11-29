class Spots::PendingsController < ApplicationController
  def index
    @pending_spots = policy_scope(Spot).where(accepted: nil)
  end
end
