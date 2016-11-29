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
end
