class Event < ApplicationRecord
  include AASM

  aasm :column => :state do
    state :pending, :initial => true
    state :published

    event :publish do
      transitions :from => :pending, :to => :published
    end
  end

  has_many :shifts, -> { order(starts_at: :asc) }, dependent: :destroy
  belongs_to :ngo

  validates :title, length: { in: 1..100 }
  validates :address, presence: true
  validates :shifts, presence: true

  accepts_nested_attributes_for :shifts, allow_destroy: true

  def self.order_by_for_select
    [:address, :title]
  end

  def earliest_shift
    shifts.first
  end

  def starts_at
    available_shifts.first.try(:starts_at)
  end

  def ends_at
    available_shifts.last.try(:ends_at)
  end
  
  def available_shifts
    shifts.
      where('volunteers_needed > volunteers_count').
      where('starts_at > NOW()')
  end

  def user_opted_in?(user)
    available_shifts.joins(:shifts_users)
      .where(shifts_users: { user_id: user.id }).any?
  end

  def volunteers_needed
    available_shifts.map(&:volunteers_needed).inject(:+)
  end

  def volunteers_count
    available_shifts.map(&:volunteers_count).inject(:+)
  end
end
