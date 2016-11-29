class ChangeSpots < ActiveRecord::Migration[5.0]
  def change
    change_column :spots, :accepted, :boolean, :default => false
  end
end
