class CreateArtisanalGeocoders < ActiveRecord::Migration[5.0]
  def change
    create_table :artisanal_geocoders do |t|
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
