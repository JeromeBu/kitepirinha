require "json"
require "open-uri"
require "pry-byebug"

class Spot < ApplicationRecord

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

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
  validates :address, presence: true

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
    lat = self.latitude
    lng = self.longitude
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
    if wind_direction_compatible?
      wing_sizes.each do |wing_size|
        score << {wing_size: wing_size, score: wing_wind_score(wing_size)}
      end
    else
      wing_sizes.each do |wing_size|
        score << {wing_size: wing_size, score: 0}
        #BAD WIND DIRECTION ;-)
      end
    end
    return score
  end

  def nav_score_max(wing_sizes)
    # Possible return values :
    # 3: BEST CONDITIONS (best conditions to kite!)
    # 2: AVERAGE CONDITIONS ! (a bit more wind or a bit less wind would be appreciated but we can kite)
    # 1: BAD CONDITIONS ! IMPOSSIBLE TO KITE (too much wind or not enough wind)
    scores = nav_score(wing_sizes)
    max = nil

    scores.each do |score_wing|
      score = score_wing[:score]
      local_score = 2 if score == 2 || score == 4
      local_score = 1 if score == 1 || score == 5
      local_score = 0 if score == 0

      if score == 3
        return 3
      end

      if max
        max = local_score if local_score > max
      else
        max = local_score
      end
    end

    if max == 0
      return 1
    end
    return max
  end

  private

  def wind_direction_compatible?
    # true if belongs to wind sector
    wind_direction = self.fresh_forecasts.first.wind_direction
    puts "Current wind direction : #{wind_direction}"
    result = []
    self.recommended_wind_directions.each do |recommended_wind_sector|
      sector_start = recommended_wind_sector[:sector_start].to_i
      sector_end = recommended_wind_sector[:sector_end].to_i
      puts "Recommended wind sector:"
      p recommended_wind_sector
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
    current_wind = fresh_forecasts.first.wind_strength
    # score for the wing (integer between 1 and 5)
    # 1 wind very light for the wing size, not navigable
    # 2 wind is a bit light for the wing size but navigable
    # 3 good conditions
    # 4 wind is a bit strong for the wing size but navigable
    # 5 wind is to strong for the wing size
    wind_for_rating = []
    WeatherFeedback::WIND_CORRESPONDANCE_75KG.each do |rating, wing_wind_h|
      wind_for_rating << wing_wind_h[wing_size]
    end

    rating = 0
    if current_wind <= wind_for_rating.first
      return 1
    elsif current_wind >= wind_for_rating.last
      return 5
    else
      wind_for_rating.each_with_index do |wind, index|
          if  current_wind >= wind
            puts "Current wind : #{current_wind}, Wind: #{wind}, Index: #{index}"
            rating = index + 1
          end
      end
    end

    return rating
  end

end

