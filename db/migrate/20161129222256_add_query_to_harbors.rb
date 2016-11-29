class AddQueryToHarbors < ActiveRecord::Migration[5.0]
  def change
    add_column :harbors, :query, :string
  end
end
