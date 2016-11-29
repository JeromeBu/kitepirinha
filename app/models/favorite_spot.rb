class FavoriteSpot < ApplicationRecord
  belongs_to :spot
  belongs_to :user

  validates :spot_id, uniqueness: { scope: :user_id }
end
