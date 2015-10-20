module AdminConfirmable
  extend ActiveSupport::Concern

  # overwrite devise methods for admin confirmation
  included do
    def active_for_authentication?
      super && admin_confirmed?
    end

    def inactive_message
      if !admin_confirmed?
        :not_admin_confimed
      else
        super # Use whatever other message
      end
    end

    def self.send_reset_password_instructions(attributes={})
      recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
      if !recoverable.admin_confirmed?
        recoverable.errors[:base] << I18n.t('devise.failure.not_admin_confimed')
      elsif recoverable.persisted?
        recoverable.send_reset_password_instructions
      end
      recoverable
    end
  end
end
