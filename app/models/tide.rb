class Tide < ApplicationRecord
  belongs_to :harbor

  validates :high_tide, presence: true
  validates :coefficient, presence: true, numericality: { only_integer: true }
  validates :date_time, presence: true
end
