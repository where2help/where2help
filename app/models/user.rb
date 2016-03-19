class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  enum locale: { de: 0, en: 1 }

  has_secure_token :api_token #That's a rails feature!

  has_many :languages_users
  has_many :languages, through: :languages_users
  has_many :abilities_users
  has_many :abilities, through: :abilities_users
  has_many :shifts_users
  has_many :shifts, through: :shifts_users

  validates :first_name, length: { in: 1..50 }
  validates :last_name, length: { in: 1..50 }
  validates :terms_and_conditions, acceptance: true

  accepts_nested_attributes_for :abilities, :languages
end
