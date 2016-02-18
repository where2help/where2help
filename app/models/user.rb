class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  has_many :languages_users
  has_many :languages, through: :languages_users

  validates :first_name, length: { in: 1..50 }
  validates :last_name, length: { in: 1..50 }
end
