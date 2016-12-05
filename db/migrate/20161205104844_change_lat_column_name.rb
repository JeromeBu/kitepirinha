class ChangeLatColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :spots, :lat, :latitude
  end
end
