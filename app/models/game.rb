class Game < ApplicationRecord
  has_one_attached :photo
  attribute :image_url, :string
end
