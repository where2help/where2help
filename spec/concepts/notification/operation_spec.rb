require "rails_helper"
require "notification/operation"

describe NotificationOperation do
  context NotificationOperation::Create do
    it "sends notifications" do
      user = create(:user)
      settings = User::Settings.new(user)
      settings.update(
        User::Settings::EMAIL_NOTIFICATION_KEY => true,
        User::Settings::FB_NOTIFICATION_KEY => true
      )
      event = create(:event, :with_shift)
      expect(UserMailer).to receive(:batch_notifications)
        .with(user: user, notifications: an_instance_of(Array)) {
          double('null').as_null_object
        }
      expect_any_instance_of(NotificationOperation::Create).to receive(:send_bot_message).with(anything, user)
      NotificationOperation::Create.(
        parent: event,
        type: :new_event,
        user_id: user.id,
        immediate: true
      )
    end
  end
end
