module User::Notifier
  class Unsent
    def self.call
      Rails.logger.info("Checking if we have any unsent messages for users")
    end
  end
end
