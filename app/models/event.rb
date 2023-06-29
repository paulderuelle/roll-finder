class Event < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :categories, through: :event_categories

  # validates :title, presence: true, uniqueness: true, length: { maximum: 30 }
  # validates :description, presence: true, length: { maximum: 300 }
  # validates :date, presence: true
  # validates :address, presence: true
  # validates :slot_number, presence: true
  # has_one_attached :photo
end
