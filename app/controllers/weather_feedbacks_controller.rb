class WeatherFeedbacksController < ApplicationController
 before_action :set_spot, only: [:new, :create]

  def new
    @weather_feedback = WeatherFeedback.new
    authorize @weather_feedback
  end

  def create
    binding.pry
    @weather_feedback = WeatherFeedback.new(weather_feedback_params)
    @weather_feedback.spot = @spot
    @weather_feedback.user = current_user
    if @weather_feedback.save
      redirect_to spot_path(@spot)
    else
      render :new
    end
    authorize @weather_feedback
  end

  private

  def weather_feedback_params
    params.require(:weather_feedback).permit(:direction, :strength, :wing_size, :rating)
  end

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end
end
