class Event < ApplicationRecord
  has_many :shifts, dependent: :destroy

  validates :shift_length, :address, presence: true

end
