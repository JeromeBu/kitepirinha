class Forecast < ApplicationRecord
  belongs_to :spot
  validates :date_time, presence: true
  validates :wind_direction, presence: true, numericality: { only_integer: true }, inclusion: { in: (0..360).to_a }
  validates :wind_strength, presence: true, numericality: true
  # validates :wind_gusting, presence: true, numericality: true
  # (pas de gustings sur l'API)
  validates :precip_intensity, presence: true, numericality: true
  validates :precip_probability, presence: true, numericality: true
  validates :cloud_cover, presence: true, numericality: true
  validates :temperature, presence: true, numericality: true
end
