class CreateSpots < ActiveRecord::Migration[5.0]
  def change
    create_table :spots do |t|
      t.references :harbor, foreign_key: true
      t.string :name
      t.float :lat
      t.float :lng
      t.text :description
      t.references :user, foreign_key: true
      t.boolean :accepted

      t.timestamps
    end
  end
end
