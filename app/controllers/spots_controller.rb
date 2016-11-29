require "json"
require "open-uri"

class SpotsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @spots = policy_scope(Spot)
    parse_forecast_data(49.3662, 0.0828)
  end

  private

  def parse_forecast_data(lat, lng)
    # Calling darksky api
    url = open("https://api.darksky.net/forecast/#{ENV['DARKSKY_API_KEY']}/#{lat},#{lng}").read
    forecast_raw_json = JSON.parse(url)
    hourly = forecast_raw_json["hourly"]
    speed = hourly["windSpeed"]
    direction = hourly["windBearing"]
    raise
    # forecast = Forecast.new({
    #   date_time: forecast_raw_json[hourly],
    #   wind_strength: forecast_raw_json[]
    #   wind_direction:
    # })

    # t.datetime "date_time"
    #   t.integer  "wind_direction"
    #   t.float    "wind_strength"
    #   t.float    "wind_gusting"
    #   t.string   "weather"
    #   t.integer  "spot_id"
  end

end
