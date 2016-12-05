class ChangeLngColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :spots, :lng, :longitude
  end
end
