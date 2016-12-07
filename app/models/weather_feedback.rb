class WeatherFeedback < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :strength, presence: true
  validates :rating, numericality: { only_integer: true }, inclusion: { in: (0..5).to_a }, allow_blank: true

  # estimation du vent selon aile pour un poid de 75kg
  # taille rating => (aile => vent)
  WIND_CORRESPONDANCE_75KG = {
    1 => {5 => 24, 6 => 21, 7 => 19, 8 => 17, 9 => 15, 10 => 13, 11 => 11.5, 12 => 10, 13 => 9, 14 => 8, 15 => 7.5, 16 => 7, 17 => 6
    },
    2 => {5 => 27, 6 => 25, 7 => 22.5, 8 => 20, 9 => 17.5, 10 => 15, 11 => 13.5, 12 => 12, 13 => 11, 14 => 10, 15 => 9.5, 16 => 9, 17 => 8.5
    },
    3 => {5 => 33, 6 => 30, 7 => 27.5, 8 => 25, 9 => 22.5, 10 => 20, 11 => 18, 12 => 16, 13 => 15, 14 => 14, 15 => 13, 16 => 12, 17 => 11
    },
    4 => {5 => 37.5, 6 => 35, 7 => 32.5, 8 => 30, 9 => 27.5, 10 => 25, 11 => 23.5, 12 => 22, 13 => 20, 14 => 18, 15 => 16.5, 16 => 15, 17 => 14
    },
    5 => {5 => 40, 6 => 37.5, 7 => 35, 8 => 32, 9 => 29, 10 => 26.5, 11 => 25, 12 => 23.5, 13 => 21.5, 14 => 19.5, 15 => 18, 16 => 17, 17 => 16
    }
  }

  def self.estimate_wind_strength(wing_size, rating)
    WIND_CORRESPONDANCE_75KG[rating][wing_size]
  end
end

