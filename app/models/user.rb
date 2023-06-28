class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookings, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :events, dependent: :destroy

  # validates :nickname, presence: true, uniqueness: true, length: { maximum: 20 }
  # validates :first_name, presence: true, length: { maximum: 20 }
  has_one_attached :photo
end
