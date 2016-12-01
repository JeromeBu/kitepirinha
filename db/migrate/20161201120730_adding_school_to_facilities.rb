class AddingSchoolToFacilities < ActiveRecord::Migration[5.0]
  def change
    add_column :facilities, :kite_school, :string
  end
end
