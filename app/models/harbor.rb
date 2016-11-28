class Harbor < ApplicationRecord
  has_many :spots
  has_many :tides
end
