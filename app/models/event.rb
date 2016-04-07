class Event < ApplicationRecord
  has_many :shifts, -> { order(starts_at: :asc) }, dependent: :destroy
  belongs_to :ngo

  validates :title, length: { in: 1..100 }
  validates :address, presence: true

  accepts_nested_attributes_for :shifts, allow_destroy: true

  def self.order_by_for_select
    [:address, :title]
  end

  def earliest_shift
    shifts.first
  end
end
