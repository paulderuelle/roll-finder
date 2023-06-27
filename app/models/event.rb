class Event < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_many :reviews
  has_many :categories, through: :event_categories
end
