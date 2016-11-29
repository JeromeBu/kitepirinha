class RecommendedWindDirection < ApplicationRecord
  belongs_to :spot
  validates :sector_start, presence: true, numericality: { only_integer: true }, inclusion: { in: (0..360).to_a }
  validates :sector_end, presence: true, numericality: { only_integer: true }, inclusion: { in: (0..360).to_a }
end
