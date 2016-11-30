require "json"
require "open-uri"

class Spot < ApplicationRecord
  # geocoded_by :name
  # after_validation :geocode, if: :name_changed?

  belongs_to :harbor
  belongs_to :user
  has_many :weather_feedbacks
  has_many :favorite_spots
  has_many :reviews
  has_many :facilities
  has_many :recommended_wind_directions
  has_many :forecasts
  has_many :harbors
  has_many :tides, through: :harbors

  validates :name, presence: true
  validates :description, presence: true

  def fresh_forecasts
    #Retourne les forecasts de moins de 2H en allant les chercher si nécessaire


  # Testing if the spot last data is older then 2 hours
    most_recent_date = 0
    self.forecasts.each do |forecast|
      most_recent_date = forecast.created_at if forecast.created_at > most_recent_date
    end
    # optimisation possible : reduire la table pour ne boucler que sur les derniers forecasts
    if DateTime.now < most_recent_date + 2.hours
      @fresh_forecasts = Forecast.where("created_at > ?", most_recent_date - 1.minutes).where(spot: self)
    else
      fetch_and_parse_forecast_data
      # code ci dessous pas DRY, on pourrait tenter un truc récursif en rappelant la fonction forecast_data
      self.forecasts.each do |forecast|
        most_recent_date = forecast.created_at if forecast.created_at > most_recent_date
      end
      @fresh_forecasts = Forecast.where("created_at > ?", most_recent_date - 2.minutes).where(spot: self)
      # fin du pas très DRY
    end
    @fresh_forecasts
  end

  def fetch_and_parse_forecast_data
    # Calling darksky api and saving in DB
    lat = self.lat
    lng = self.lng
    url = open("https://api.darksky.net/forecast/#{ENV['DARKSKY_API_KEY']}/#{lat},#{lng}?units=ca").read
    forecast_raw_json = JSON.parse(url)

    hourly = forecast_raw_json["hourly"]["data"]

    hourly.each do |data_for_the_hour|
      forecast = Forecast.new({
        spot: self,
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

