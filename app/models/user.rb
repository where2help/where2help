class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  has_secure_token :api_token #That's a rails feature!

  has_many :languages_users
  has_many :languages, through: :languages_users
  has_many :abilities_users
  has_many :abilities, through: :abilities_users

  validates :first_name, length: { in: 1..50 }
  validates :last_name, length: { in: 1..50 }
end
