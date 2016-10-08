class Shift < ApplicationRecord
  default_scope { order(starts_at: :asc) }
  paginates_per 10

  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  belongs_to :event

  validates :volunteers_needed, :starts_at, :ends_at, presence: true
  validate :not_in_past
  validate :ends_at_after_starts_at

  scope :not_full,  -> { where('volunteers_needed > volunteers_count') }
  scope :past,      -> { where('starts_at < NOW()').reorder(starts_at: :desc) }
  scope :upcoming,  -> { where('starts_at > NOW()') }
  scope :available, -> { upcoming.not_full }

  before_destroy :notify_volunteers_about_destroy, prepend: true
  before_update  :notify_volunteers_about_update, prepend: true

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
