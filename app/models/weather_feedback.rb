class WeatherFeedback < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :strength, presence: true
  validates :rating, numericality: { only_integer: true }, inclusion: { in: (0..5).to_a }
end
