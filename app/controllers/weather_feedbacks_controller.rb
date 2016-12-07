class WeatherFeedbacksController < ApplicationController
 before_action :set_spot, only: [:new, :create]

  def new
    @weather_feedback = WeatherFeedback.new
    authorize @weather_feedback
  end

  def create

    wind_strength_estimation = WeatherFeedback.estimate_wind_strength(params[:wing_size].to_i, params[:wing_size_exp_rating].to_i)
    @weather_feedback = WeatherFeedback.new(
      direction: params[:wind_measured_angle],
      strength: wind_strength_estimation = params[:wing_size],
      wing_size: params[:wing_size],
      rating: params[:wing_size_exp_rating])
    @weather_feedback.user = current_user
    @weather_feedback.spot = @spot


    if @weather_feedback.save
      respond_to do |format|
        format.html { redirect_to spot_path(@spot) }
        format.js  # <-- will render `app/views/weather_feedbacks/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'spots/show' }
        format.js  # <-- idem
      end
    end


    # if @weather_feedback.save
    #   redirect_to spot_path(@spot)
    # else
    #   render :new
    # end
    authorize @weather_feedback
  end

  private

  # def weather_feedback_params
  #   params.require(:weather_feedback).permit(:direction, :wing_size, :rating)
  # end

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end
end
