class Spot < ApplicationRecord
  belongs_to :harbor
  belongs_to :user
end
