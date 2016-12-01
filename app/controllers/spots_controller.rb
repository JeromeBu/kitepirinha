class SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :edit, :update]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @spots_index = policy_scope(Spot)
    @spots = Spot.where.not(lat: nil, lng: nil)

    @hash = Gmaps4rails.build_markers(@spots) do |spot, marker|
      marker.lat spot.lat
      marker.lng spot.lng
      # marker.infowindow render_to_string(partial: "/spots/map_box", locals: { spot: spot })
    end
  end

  def show
    @mean_weather_feedback = @spot.mean_weather_feedback
    @review = Review.new
    authorize @review
  end

  def new
    @spot = current_user.spots.new
    authorize @spot
  end

  def create
    @spot = Spot.new(spot_params)
    a = ArtisanalGeocoder.geo(spot_params[:address])
    @spot.user= current_user
    @spot.lat = a[:lat]
    @spot.lng = a[:lng]
    authorize @spot
    @spot.harbor = Harbor.find_closest_from(@spot.lat, @spot.lng)
    if @spot.save
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
    params.require(:spot).permit(:name, :description, :lat, :lng, :address)
  end
end
