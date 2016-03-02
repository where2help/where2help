class Ngo < ApplicationRecord
  include AASM
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
         
  enum locale: { de: 0, en: 1 }

  has_one :contact, dependent: :destroy, inverse_of: :ngo
  accepts_nested_attributes_for :contact, reject_if: :all_blank

  validates :name, presence: true
  validates :identifier, presence: true
  validates_presence_of :contact

  after_commit :request_admin_confirmation, on: :create

  aasm do
    state :pending, initial: true
    state :admin_confirmed
    state :deactivated

    event :admin_confirm do
      transitions from: :pending, to: :admin_confirmed, after: :send_admin_confirmation
      transitions from: :deactivated, to: :admin_confirmed
    end

    event :deactivate, after: :reset_confirmations do
      transitions from: [:pending, :admin_confirmed], to: :deactivated
    end
  end

  def self.send_reset_password_instructions(attributes={})
   recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
   if !recoverable.admin_confirmed?
     recoverable.errors[:base] << I18n.t('devise.failure.not_admin_confirmed')
   elsif recoverable.persisted?
     recoverable.send_reset_password_instructions
   end
   recoverable
 end

  # overwrite devise to require admin confirmation too
  def active_for_authentication?
    super && admin_confirmed?
  end

  # custom message if requires admin confirmation
  def inactive_message
    admin_confirmed? ? :not_admin_confirmed : super
  end

  private

  def request_admin_confirmation
    AdminMailer.new_ngo(self).deliver_later
  end

  def send_admin_confirmation
    NgoMailer.admin_confirmed(self).deliver_later
  end

  def reset_confirmations
    update(confirmation_token: nil,
            confirmed_at: nil,
            confirmation_sent_at: nil)
  end
end
