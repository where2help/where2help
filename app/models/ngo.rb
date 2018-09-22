class Ngo < ApplicationRecord
  acts_as_paranoid
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  enum locale: { de: 0, en: 1 }

  scope :pending,   -> { where(admin_confirmed_at: nil) }
  scope :confirmed, -> { where.not(admin_confirmed_at: nil) }

  has_many :events,         dependent: :restrict_with_error, inverse_of: :ngo
  has_many :ongoing_events, dependent: :restrict_with_error, inverse_of: :ngo
  has_one  :contact,        dependent: :destroy, inverse_of: :ngo

  accepts_nested_attributes_for :contact

  validates :name,                 presence: true
  validates :contact,              presence: true
  validates :terms_and_conditions, acceptance: true

  after_commit :request_admin_confirmation, on: :create

  def confirm!
    if !admin_confirmed?
      update(admin_confirmed_at: Time.now)
      send_admin_confirmation
    end
  end

  def state
    _state = %w(deleted confirmed).find { |state| send("#{state}?") }
    _state || 'pending'
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.confirmed?
      recoverable.errors[:base] << I18n.t('devise.failure.not_admin_confirmed')
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  # overwrite devise to require admin confirmation too
  def active_for_authentication?
    super && confirmed?
  end

  # custom message if requires admin confirmation
  def inactive_message
    if !confirmed?
      if email_confirmed?
        return :not_admin_confirmed
      else
        return :unconfirmed
      end
    end
    super
  end

  def new_event
    t           = Time.now + 15.minutes
    starts      = t - t.sec - t.min%15*60
    ends        = starts +  2.hours
    shifts_attr = [{ volunteers_needed: 1, starts_at: starts, ends_at: ends }]
    events.build(shifts_attributes: shifts_attr)
  end

  def confirmed?
    email_confirmed? && admin_confirmed?
  end

  private

  def admin_confirmed?
    admin_confirmed_at.present?
  end

  def email_confirmed?
    confirmed_at.present?
  end

  def request_admin_confirmation
    AdminMailer.new_ngo(self).deliver_later
  end

  def send_admin_confirmation
    NgoMailer.admin_confirmed(self).deliver_later
  end
end
