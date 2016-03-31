class Event < ApplicationRecord
  has_many :shifts, dependent: :destroy
  belongs_to :ngo

  validates :title, length: { in: 1..100 }
  validates :address, presence: true

  accepts_nested_attributes_for :shifts
end
