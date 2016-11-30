class Harbor < ApplicationRecord
  has_many :spots
  has_many :tides
  validates :name, presence: true
  validates :lat, presence: true, numericality: true
  validates :lng, presence: true, numericality: true

  def self.find_closest_from(lat, lng)
    require 'geocoding_tools.rb'
    find_closest(self.all, lat, lng)
  end
end
