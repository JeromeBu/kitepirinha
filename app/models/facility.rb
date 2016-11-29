class Facility < ApplicationRecord
  belongs_to :spot
  validates :parking, presence: true
  validates :safety_watch, presence: true
  validates :comment, presence: true
end
