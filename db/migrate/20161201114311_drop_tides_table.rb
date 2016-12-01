class DropTidesTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :tides
  end
end
