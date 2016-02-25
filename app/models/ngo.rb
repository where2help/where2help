class Ngo < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  enum locale: { de: 0, en: 1 }

  has_one :contact, dependent: :destroy

  validates :name, presence: true
  validates :identifier, presence: true
end
