class SpotsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @spots = policy_scope(Spot)
  end
end
