class UserOperation
  class UpdateNotifications < Operation
    def process(notification_settings:, current_user:, **)
      settings = User::Settings.new(current_user)
      settings.update(notification_settings)
    end
  end
end
