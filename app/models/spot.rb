require "json"
require "open-uri"

class Spot < ApplicationRecord

  # geocoded_by :address
  # after_validation :geocode
  has_attachment :photo

  belongs_to :harbor
  belongs_to :user
  has_many :weather_feedbacks, dependent: :destroy
  has_many :favorite_spots, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :facility, dependent: :destroy
  has_many :recommended_wind_directions, dependent: :destroy
  has_many :forecasts, dependent: :destroy
  has_many :harbors

  validates :name, presence: true
  validates :description, presence: true

  def fresh_forecasts
    #Retourne les forecasts de moins de 2H en allant les chercher si nécessaire
    if self.forecasts.empty?
      fetch_and_parse_forecast_data
    end

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
    @fresh_forecasts.sort_by { |k| k["date_time"] }
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

  def mean_weather_feedback
    last_feedbacks = self.weather_feedbacks.where("created_at > ?", DateTime.now - 4.hours)
    if last_feedbacks.empty?
      mean_feedback = {message: "No recent data for this spot"}
    else
      sum_strength = 0
      sum_x_direction = 0
      sum_y_direction = 0
      max_strength = 0
      min_strength = 200
      last_feedback = last_feedbacks.last
      last_feedbacks.each do |feedback|
        max_strength = feedback.strength if feedback.strength > max_strength
        min_strength = feedback.strength if feedback.strength < min_strength
        sum_strength = sum_strength + feedback.strength
        sum_x_direction = sum_x_direction + Math.cos(feedback.direction * Math::PI / 180)
        sum_y_direction = sum_y_direction + Math.sin(feedback.direction * Math::PI / 180)
        last_feedback = feedback if feedback.created_at > last_feedback.created_at
      end
      mean_strength = (sum_strength/last_feedbacks.length).round(1)
      mean_x_direction = (sum_x_direction/last_feedbacks.length)
      mean_y_direction = (sum_y_direction/last_feedbacks.length)
      mean_direction = (Math.atan2(mean_y_direction, mean_x_direction) * 180 / Math::PI).round
      mean_direction = mean_direction + 360 if mean_direction < 0
      mean_feedback = {
        message: "#{last_feedbacks.length} feedbacks in the 2 past hours, last one at #{last_feedback.created_at.strftime('%H:%M')}",
        mean_strength: mean_strength,
        mean_direction: mean_direction,
        max_strength: max_strength,
        min_strength: min_strength,
        last_feedback: last_feedback
      }
    end
  end

  def average_rating
    ratings = self.reviews.map { |r| r.rating }
    average = ratings.inject{ |sum, el| sum + el }.to_f / ratings.size if !ratings.empty?
    average
  end

  def nav_score(wing_sizes)

    #Inputs (wing_sizes = [8, 5] etc..in m squarred)
    #Returns array of hashes : [{score: 4, wing_size: 8}, {score: 2, wing_size: 5}]

    score = []
    if wind_direction_compatible
      wing_sizes.each do |wing_size|
        score << {wing_size: wing_size, score: wing_wind_score(wing_size)}
      end
    else
      wing_sizes.each do |wing_size|
        score << {wing_size: wing_size, score: 0}
      end
    end
  end



  def wind_direction_compatible?
    # true if belongs to wind sector
    wind_direction = self.forecasts.first[:wind_direction]
    result = []
    self.recommended_wind_directions.each do |recommended_wind_sector|
      sector_start = recommended_wind_sector[:sector_start].to_i
      sector_end = recommended_wind_sector[:sector_end].to_i

      if sector_start > sector_end
        sector_end += 360
        wind_direction += 360
      end

      if sector_start <= wind_direction &&  wind_direction <= sector_end
        result << true
      else
        result << false
      end
    end
    return result.include?(true)
  end

  def wing_wind_score(wing_size)
    # score for the wing (integer between 1 and 5)
    # 1 wind very light for the wing size, not navigable
    # 2 wind is a bit light for the wing size but navigable
    # 3 good conditions
    # 4 wind is a bit strong for the wing size but navigable
    # 5 wind is to strong for the wing size
  end


end

