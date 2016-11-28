class CreateTides < ActiveRecord::Migration[5.0]
  def change
    create_table :tides do |t|
      t.references :harbor, foreign_key: true
      t.boolean :high_tide
      t.integer :coefficient
      t.datetime :date_time

      t.timestamps
    end
  end
end
