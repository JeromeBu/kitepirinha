class ReviewsController < ApplicationController

  def new
    @review = Review.new
  end

  def create
    @spot = Spot.find(params[spot_id])
    @review = Review.new(review_params)
    @review.spot = @spot
    @review.user = current_user
    @review.save
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end

end
