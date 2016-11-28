class CreateHarbors < ActiveRecord::Migration[5.0]
  def change
    create_table :harbors do |t|
      t.string :name
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
