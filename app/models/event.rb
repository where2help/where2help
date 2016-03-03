class Event < ApplicationRecord
  has_many :shifts, dependent: :destroy

  validates :volunteers_needed, :starts_at, :ends_at, presence: true
  validates :shift_length, :address, presence: true

end
