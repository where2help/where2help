class Ngo < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  has_one :contact, dependent: :destroy

  validates :name, presence: true
  validates :identifier, presence: true
end
