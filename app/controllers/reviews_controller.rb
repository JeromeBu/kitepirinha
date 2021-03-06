class ReviewsController < ApplicationController
  before_action :set_spot, only: [:new, :create]

  # def new
  #   @review = Review.new
  #   authorize @review
  # end

  def create
    @review = Review.new(review_params)
    @review.spot = @spot
    @review.user = current_user
    # if @review.save
    #   redirect_to spot_path(@spot)
    # else
    #   render :new
    # end

    #AJAX in the spot show
    if @review.save
      respond_to do |format|
        format.html { redirect_to spot_path(@spot) }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'spots/show' }
        format.js  # <-- idem
      end
    end

    authorize @review
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end

  def set_spot
    @spot = Spot.find(params[:spot_id])
    authorize @spot
  end

end

