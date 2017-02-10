desc "This task is called by the Heroku scheduler add-on"

# task :fakejob => :environment do
#   puts "Doing the fake job"
#   sleep 3
#   puts "Fake job finished"
# end

task :update_forecasts => :environment do
  spots = Spot.all
    spots.each do |spot|
    lat = spot.latitude
    lng = spot.longitude
    url = open("https://api.darksky.net/forecast/#{ENV['DARKSKY_API_KEY']}/#{lat},#{lng}?units=ca").read
    forecast_raw_json = JSON.parse(url)

    hourly = forecast_raw_json["hourly"]["data"]

    hourly.each do |data_for_the_hour|
      forecast = Forecast.new({
        spot: spot,
        date_time: DateTime.strptime(data_for_the_hour["time"].to_s, '%s'),
        wind_strength: (data_for_the_hour["windSpeed"]/1.852), # vitesse du vent enregistrée en kt
        wind_direction: data_for_the_hour["windBearing"],
        precip_intensity: data_for_the_hour["precipIntensity"],
        precip_probability: data_for_the_hour["precipProbability"],
        cloud_cover: data_for_the_hour["cloudCover"],
        temperature: data_for_the_hour["temperature"],
        icon: data_for_the_hour["icon"]
      })
      forecast.save
    end
    spot.forecasts.where("created_at < ?", DateTime.now - 90.minutes).destroy_all
  end
end
