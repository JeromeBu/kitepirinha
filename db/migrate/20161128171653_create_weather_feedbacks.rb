class CreateWeatherFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :weather_feedbacks do |t|
      t.references :user, foreign_key: true
      t.references :spot, foreign_key: true
      t.integer :direction
      t.float :strength
      t.float :wing_size
      t.integer :rating

      t.timestamps
    end
  end
end
