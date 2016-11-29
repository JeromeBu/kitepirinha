class Harbor < ApplicationRecord
  has_many :spots
  has_many :tides
  validates :name, presence: true
  validates :lat, presence: true, numericality: true
  validates :lng, presence: true, numericality: true
end
