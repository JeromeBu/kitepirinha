class ArtisanalGeocoder < ApplicationRecord
  geocoded_by :address
  after_validation :geocode

  def self.geo(address)
    a = ArtisanalGeocoder.create(address: address)
    b = {lat: a.latitude, lng: a.longitude}
    a.destroy
    return b
  end
end
