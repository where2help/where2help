class Ngo < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  scope :unconfirmed, -> { where(admin_confirmed_at: nil) }
  scope :confirmed, -> { where.not(admin_confirmed_at: nil) }

  enum locale: { de: 0, en: 1 }

  has_one :contact, dependent: :destroy, inverse_of: :ngo
  accepts_nested_attributes_for :contact, reject_if: :all_blank

  validates :name, presence: true
  validates :identifier, presence: true
  validates_presence_of :contact

  after_commit :request_admin_confirmation, on: :create

  def self.send_reset_password_instructions(attributes={})
   recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
   if !recoverable.admin_confirmed_at?
     recoverable.errors[:base] << I18n.t('devise.failure.not_admin_confirmed')
   elsif recoverable.persisted?
     recoverable.send_reset_password_instructions
   end
   recoverable
 end

  # overwrite devise to require admin confirmation too
  def active_for_authentication?
    super && admin_confirmed_at?
  end

  # custom message if requires admin confirmation
  def inactive_message
    admin_confirmed_at ? :not_admin_confirmed : super
  end

  def admin_confirm!
    update admin_confirmed_at: Time.now
    NgoMailer.admin_confirmed(self).deliver_later
  end

  private

  def request_admin_confirmation
    AdminMailer.new_ngo(self).deliver_later
  end
end
