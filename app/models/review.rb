class Review < ApplicationRecord
  belongs_to :spot
  belongs_to :user

  validates :content, presence: true
  validates :rating, presence: true, numericality: { only_integer: true }, inclusion: { in: (0..5).to_a }
end
