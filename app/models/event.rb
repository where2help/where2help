class Event < ApplicationRecord
  include AASM

  belongs_to :ngo
  has_many :shifts, -> { order(starts_at: :asc) }, dependent: :destroy
  has_many :available_shifts, -> { available }, class_name: 'Shift'
  has_many :future_shifts, -> { upcoming }, class_name: 'Shift'

  validates :title, length: { in: 1..100 }
  validates :address, presence: true
  validates :shifts, presence: true

  accepts_nested_attributes_for :shifts, allow_destroy: true

  scope :with_available_shifts, -> {
    published.
    includes(:available_shifts, :shifts).
    where(id: Shift.available.pluck(:event_id).uniq).
    order('shifts.starts_at ASC')
  }
  scope :upcoming, -> { where(id: Shift.upcoming.pluck(:event_id).uniq) }
  scope :past, -> { where(id: Shift.past.pluck(:event_id).uniq) }

  aasm column: :state do
    state :pending, initial: true
    state :published

    event :publish do
      transitions from: :pending, to: :published
    end
  end

  def self.filter(scope=nil, order=nil)
    scopes = [:all, :past, :upcoming]
    scope ||= :all
    raise ArgumentError.new('Invalid scope given') unless scopes.include?(scope)
    send(scope).try(:order_by, order)
  end

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

  def ngo_volunteers_needed
    shifts.map(&:volunteers_needed).inject(:+)
  end

  def ngo_volunteers_count
    shifts.map(&:volunteers_count).inject(:+)
  end

  private

  def self.order_by(order)
    orders = [nil, :address, :title]
    raise ArgumentError.new('Invalid order key given') unless orders.include?(order)
    send(:order, order)
  end
end
