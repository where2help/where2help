class Shift < ApplicationRecord
  belongs_to :event
  validates :volunteers_needed, :starts_at, :ends_at, presence: true
end
