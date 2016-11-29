require "json"
require "open-uri"

class SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :edit, :update]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @spots = policy_scope(Spot)
    # forecast_data(Spot.first)
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
    require.params(:spot).permit(:description, :lat, :lng, :user_id)
  end

  def forecast_data(spot)
  # Testing if the spot last data is older then 2 hours
    most_recent_date = 0
    spot.forecasts.each do |forecast|
      most_recent_date = forecast.created_at if forecast.created_at > most_recent_date
    end

    if DateTime.now < most_recent_date + 2.hours
      Forecast.where("created_at > ?", most_recent_date - 1.minutes).where(spot: spot)
    else
      parse_forecast_data(spot)
      # code ci dessous pas DRY, on pourrait tenter un truc récursif en rappelant la fonction forecast_data
      spot.forecasts.each do |forecast|
        most_recent_date = forecast.created_at if forecast.created_at > most_recent_date
      end
      Forecast.where("created_at > ?", most_recent_date - 2.minutes).where(spot: spot)
      # fin du pas très DRY
    end
  end

  def parse_forecast_data(spot)
    # Calling darksky api and saving in DB
    lat = spot.lat
    lng = spot.lng
    url = open("https://api.darksky.net/forecast/#{ENV['DARKSKY_API_KEY']}/#{lat},#{lng}?units=ca").read
    forecast_raw_json = JSON.parse(url)

    hourly = forecast_raw_json["hourly"]["data"]

    hourly.each do |data_for_the_hour|
      forecast = Forecast.new({
        spot: spot,
        date_time: DateTime.strptime(data_for_the_hour["time"].to_s, '%s'),
        wind_strength: (data_for_the_hour["windSpeed"]/1.852), # vitesse du vent enregistrée en kt
        wind_direction: data_for_the_hour["windBearing"],
        precip_intensity: data_for_the_hour["precipIntensity"],
        precip_probability: data_for_the_hour["precipProbability"],
        cloud_cover: data_for_the_hour["cloudCover"],
        temperature: data_for_the_hour["temperature"]
      })
      forecast.save
    end
  end
end
