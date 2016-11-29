class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :reviews
  has_many :weather_feedbacks
  has_many :spots
  has_many :favorite_spots

  validates :weight, numericality: { only_integer: true }
end
