class Shift < ApplicationRecord
  default_scope { order(starts_at: :asc) }
  paginates_per 10

  has_many :shifts_users, dependent: :destroy
  has_many :users, through: :shifts_users
  belongs_to :event

  validates :volunteers_needed, :starts_at, :ends_at, presence: true
  validate :not_in_past

  scope :not_full, -> { where('volunteers_needed > volunteers_count') }
  scope :past, -> { where('starts_at < NOW()').reorder(starts_at: :desc) }
  scope :upcoming, -> { where('starts_at > NOW()') }
  scope :available, -> { upcoming.not_full }

  before_destroy :notify_volunteers, prepend: true

  def self.filter(scope=nil)
    scope ||= :upcoming
    send(scope)
  end

  private

  def notify_volunteers
    users.find_each do |user|
      # calling deliver_now here because othewise won't have shift available
      UserMailer.shift_destroyed(self, user).deliver_now
    end
  end

  def not_in_past
   errors.add(:starts_at, :not_in_past) if starts_at && starts_at < Time.now()
   errors.add(:ends_at, :not_in_past)   if ends_at && ends_at < Time.now
 end
end
