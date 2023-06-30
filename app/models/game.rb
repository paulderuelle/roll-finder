class Game < ApplicationRecord
  has_one_attached :photo
  # attribute :image_url, :string
  has_many :event_games
  has_many :events, through: :event_games
end
