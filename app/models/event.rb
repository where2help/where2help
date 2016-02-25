class Event < ApplicationRecord
  validates :category, :volunteers_needed, :starts_at, :ends_at, presence: true
  validates :shift_length, :address, presence: true

  enum category: { volunteer: 0, medical: 1, legal: 2 }
end
