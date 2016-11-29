class Forecast < ApplicationRecord
  belongs_to :spot
  validates :date_time
  validates :wind_direction, presence: true, numericality: { only_integer: true }, inclusion: { in: (0..360).to_a }
  validates :wind_strength, presence: true, numericality: true
  validates :wind_gusting, presence: true, numericality: true
  # validates :  weather en fonction de ce que renvoie l'API
end
