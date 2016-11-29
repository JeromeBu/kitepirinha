class ChangeDefaultValueSpots < ActiveRecord::Migration[5.0]
  def change
    change_column :spots, :accepted, :boolean, :default => nil
  end
end
