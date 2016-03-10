class Event < ApplicationRecord
  has_many :shifts, dependent: :destroy

  validates :shift_length, :address, presence: true

  accepts_nested_attributes_for :shifts
end
