class CreateForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :forecasts do |t|
      t.datetime :date_time
      t.integer :wind_direction
      t.float :wind_strength
      t.float :wind_gusting
      t.string :weather
      t.references :spot, foreign_key: true

      t.timestamps
    end
  end
end
