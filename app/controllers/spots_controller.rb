class SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :edit, :update]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @spots_index = policy_scope(Spot)

    if params[:address] == nil || params[:address] == ""
      @spots = Spot.where.not(latitude: nil, longitude: nil)
    else
      @spots = Spot.near(params[:address], 50).where.not(latitude: nil, longitude: nil)
    end

    # à remplacer par les params selon la recherche home page
    params["selected-wing-sizes"] == nil if params["selected-wing-sizes"] == ""

    if params["selected-wing-sizes"] == nil
      @wing_sizes = [6, 8, 10, 13, 15]
    else
      @wing_sizes = params["selected-wing-sizes"].split(",")
      @wing_sizes.map! do |wing_size|
        wing_size.to_i
      end
    end
    #########################################################

    @hash = Gmaps4rails.build_markers(@spots.reverse) do |spot, marker|
      score = spot.nav_score_max(@wing_sizes)
      if score == 1
        color = "red"
      elsif score == 2
        color = "yellow"
      elsif score == 3
        color = "green"
      end

      marker.lat spot.latitude
      marker.lng spot.longitude
      marker.infowindow render_to_string(partial: "/spots/map_box", locals: { spot: spot })
      marker.picture({
        url: view_context.image_url("#{color}-flag.svg"),
        width:  70,
        height: 70
      })
    end

    @condition_icons = { "clear-day" => "clear_day.svg", "clear-night" => "clear_night.svg", "rain" => "rain.svg", "snow" => "snow.svg", "sleet" => "sleet.svg", "wind" => "wind.svg", "fog" => "fog.svg", "cloudy" => "cloudy.svg", "partly-cloudy-day" => "partly_cloudy_day.svg", "partly-cloudy-night" => "partly_cloudy_night.svg" }
    @condition_string = { "clear-day" => "Clear Day", "clear-night" => "Clear Night", "rain" => "Raining", "snow" => "Snowing", "sleet" => "Sleet", "wind" => "Windy", "fog" => "Foggy", "cloudy" => "Cloudy", "partly-cloudy-day" => "Partly Cloudy Day", "partly-cloudy-night" => "Partly Cloudy Night" }
  end

  def show
    @mean_weather_feedback = @spot.mean_weather_feedback
    @forecasts = @spot.fresh_forecasts
    @review = Review.new
    @feedback = WeatherFeedback.new
    authorize @review

    @condition_icons = { "clear-day" => "clear_day.svg", "clear-night" => "clear_night.svg", "rain" => "rain.svg", "snow" => "snow.svg", "sleet" => "sleet.svg", "wind" => "wind.svg", "fog" => "fog.svg", "cloudy" => "cloudy.svg", "partly-cloudy-day" => "partly_cloudy_day.svg", "partly-cloudy-night" => "partly_cloudy_night.svg" }
    @condition_string = { "clear-day" => "Clear Day", "clear-night" => "Clear Night", "rain" => "Raining", "snow" => "Snowing", "sleet" => "Sleet", "wind" => "Windy", "fog" => "Foggy", "cloudy" => "Cloudy", "partly-cloudy-day" => "Partly Cloudy Day", "partly-cloudy-night" => "Partly Cloudy Night" }
  end

  def new
    @spot = current_user.spots.new
    authorize @spot
  end

  def create
    @spot = Spot.new(spot_params)
    @spot.user = current_user
    authorize @spot
    if @spot.save
      @spot.harbor = Harbor.find_closest_from(@spot.latitude, @spot.longitude)
      @spot.fetch_and_parse_forecast_data
      @spot.save
      redirect_to spot_path(@spot)
    else
      render :new
    end
  end

  def edit
  end

  def update
    # si le spot vient d'être ajouté et donc accepted = nil
    # je veux l'afficher à un ambassadeur et lui laisser le choix d'accepter ou décliner

    if @spot.accepted = "nil"
      if params[:do] == "accept"
        @spot.update(accepted: true)
      elsif params[:do] == "decline"
        @spot.update(accepted: false)
      end

    # comportement normal autrement, autrement dit si accepted est différent de nil et a donc déjà été traité
    else
      @spot.update(spot_params)
    end

    # quels que soient les changements, je sauvegarde
    if @spot.save
      redirect_to spot_path(@spot)
    else
      render :edit
    end
  authorize @spot
  end

  def destroy
    @spot.destroy
    redirect_to spots_path
  end

  private

  def set_spot
    @spot = Spot.find(params[:id])
    authorize @spot
  end

  def spot_params
    params.require(:spot).permit(:name, :description, :latitude, :longitude, :address, :photo)
  end
end
