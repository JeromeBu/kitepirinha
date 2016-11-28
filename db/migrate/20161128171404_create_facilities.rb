class CreateFacilities < ActiveRecord::Migration[5.0]
  def change
    create_table :facilities do |t|
      t.string :parking
      t.string :water_spot
      t.string :shop
      t.string :rescue
      t.string :shower
      t.text :comment
      t.references :spot, foreign_key: true

      t.timestamps
    end
  end
end
