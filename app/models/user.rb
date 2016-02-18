class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  validates :first_name, length: { in: 1..50 }
  validates :last_name, length: { in: 1..50 }
end
