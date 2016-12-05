class AddColumnToForecasts < ActiveRecord::Migration[5.0]
  def change
    add_column :forecasts, :icon, :string
  end
end
