class CreateRecommendedWindDirections < ActiveRecord::Migration[5.0]
  def change
    create_table :recommended_wind_directions do |t|
      t.references :spot, foreign_key: true
      t.integer :sector_start
      t.integer :sector_end

      t.timestamps
    end
  end
end
