class Shift < ApplicationRecord
  acts_as_paranoid without_default_scope: true
  default_scope { where(deleted_at: nil).order(starts_at: :asc) }
  paginates_per 10

  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  belongs_to :event

  validates :volunteers_needed, :starts_at, :ends_at, presence: true
  validate :not_in_past
  validate :ends_at_after_starts_at

  scope :not_full,    -> { where('volunteers_needed > volunteers_count') }
  scope :past,        -> { where('ends_at <= NOW()').reorder(starts_at: :desc) }
  scope :upcoming,    -> { where('ends_at > NOW()') }
  scope :available,   -> { upcoming.not_full }
  scope :not_deleted, -> { where(deleted_at: nil) }

  before_destroy :notify_volunteers_about_destroy, prepend: true
  after_update   :notify_volunteers_about_update,  prepend: true

  def self.filtered_for_ngo(ngo, filters)
    the_scope, order_by = filters
    # unscoped is necessary because default_scope (deprecated?) is
    # messing up the order by
    shifts =
      unscoped
      .not_deleted
      .not_full
      .includes(:event)
      .select("date(starts_at) as starts, max(starts_at) as max_starts_at, event_id")
      .where(event_id: ngo.events.pluck(:id))
      .group("starts, event_id")
      .order("max_starts_at, event_id")

    if order_by && Event.order_by_for_select.include?(order_by)
      shifts = shifts.sort_by{ |shift|
        shift.event.send(order_by)
      }
    end

    # skip if no scope
    case the_scope
    when :past
      shifts = shifts.select { |shift| shift.max_starts_at < Time.now }
    when :upcoming
      shifts = shifts.select { |shift| shift.max_starts_at > Time.now }
    end
    shifts
  end

  def self.filter(scope = nil)
    scope ||= :upcoming
    valid_scope = [:all, :past, :upcoming].include? scope
    raise ArgumentError.new('Invalid scope given') unless valid_scope
    send(scope)
  end

  def progress_bar(user = nil)
    offset = users.where(id: user.try(:id)).count
    ProgressBar.new(
      progress: volunteers_count,
      total:    volunteers_needed,
      offset:   offset)
  end

  private

  def notify_volunteers_about_destroy
    users.find_each do |user|
      # calling deliver_now here because othewise won't have shift available
      UserMailer.shift_destroyed(self, user).deliver_now
    end
  end

  def notify_volunteers_about_update
    users.find_each do |user|
      UserMailer.shift_updated(self, user).deliver_now
    end
  end

  def not_in_past
   errors.add(:starts_at, :not_in_past) if starts_at && starts_at < Time.now()
   errors.add(:ends_at, :not_in_past)   if ends_at && ends_at < Time.now
  end

  def ends_at_after_starts_at
    errors.add(:ends_at, :ends_at_before_starts_at) if starts_at && ends_at && starts_at > ends_at
  end
end
