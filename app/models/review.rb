class Review < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates_numericality_of :rating, in: 0..5
end
