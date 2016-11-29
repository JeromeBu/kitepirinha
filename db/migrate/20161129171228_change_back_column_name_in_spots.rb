class ChangeBackColumnNameInSpots < ActiveRecord::Migration[5.0]
  def change
    rename_column :spots, :latitude, :lat
    rename_column :spots, :longitude, :lng
  end
end
