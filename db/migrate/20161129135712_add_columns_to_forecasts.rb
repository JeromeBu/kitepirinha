class AddColumnsToForecasts < ActiveRecord::Migration[5.0]
  def change
    add_column :forecasts, :precip_intensity, :float
    add_column :forecasts, :precip_probability, :float
    add_column :forecasts, :cloud_cover, :float
    add_column :forecasts, :temperature, :float
  end
end
