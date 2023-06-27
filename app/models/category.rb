class Category < ApplicationRecord
  has_many :events, through: :event_categories
end
