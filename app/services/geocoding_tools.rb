# app/services/geocoding_tools.rb

def find_closest collection, lat, lng
  currently_closest_item = nil
  current_min_distance = nil
  loc1 = []
  loc2 = []
  collection.each do |object|
    loc1[0] = object.lat
    loc1[1] = object.lng
    loc2[0] = lat
    loc2[1] = lng
    distance_between_loc1_and_loc2 = distance loc1, loc2
    if !currently_closest_item || distance_between_loc1_and_loc2 < current_min_distance
      currently_closest_item = object
      current_min_distance = distance_between_loc1_and_loc2
    end
  end
  return currently_closest_item
end

def distance loc1, loc2
  rad_per_deg = Math::PI/180  # PI / 180
  rkm = 6371                  # Earth radius in kilometers
  rm = rkm * 1000             # Radius in meters

  dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
  dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

  lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
  lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  rm * c # Delta in meters
end
