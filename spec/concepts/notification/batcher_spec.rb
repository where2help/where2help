require "rails_helper"

describe Notification::Batcher do
  context "#unsent_messages" do
    it "gets unsent notifications" do
      sent = Notification.create(sent_at: Time.now - 86400)
      unsent = Notification.create(sent_at: nil)
      expect(Notification::Batcher.new.unsent_messages.values.flatten).to eq([unsent])
    end

    it "organizes by user" do
      user = create(:user)
      user.notifications.create
      expect(Notification::Batcher.new.unsent_messages.keys).to eq([user.id])
    end
  end

  context "#filter_notifications" do
    it "filters out when user doesn't receive notif" do
      user = create(:user)
      settings = User::Settings.new(user)
      settings.setup_new_user!
      settings.update(User::Settings::NEW_EVENT_KEY => false)
      notif = user.notifications.create(notification_type: :new_event)
      filtered = Notification::Batcher.new.filter_notifications([notif])
      expect(filtered).to eq([])
    end

    it "keeps ones that it should" do
      user = create(:user)
      settings = User::Settings.new(user)
      settings.setup_new_user!
      settings.update(User::Settings::NEW_EVENT_KEY => true)
      notif = user.notifications.create(notification_type: :new_event)
      filtered = Notification::Batcher.new.filter_notifications([notif])
      expect(filtered).to eq([notif])
    end
  end

  context "#present_notifications" do
    it "creates a notification template" do
      user = create(:user)
      event = create(:event, :with_shift)
      settings = User::Settings.new(user)
      settings.setup_new_user!
      settings.update(User::Settings::NEW_EVENT_KEY => true)
      notif = user.notifications.create(notification_type: :new_event, notifiable: event)
      presenter = Notification::Batcher.new.present_notifications([notif])
      expect(presenter.locale).to eq(user.locale)
      expect(presenter.user).to eq(user)
      expect(presenter.notifications).to eq([notif])
    end
  end

  context "#mark_sent" do
    it "marks sent notifications as sent" do
      batcher = Notification::Batcher.new
      notif = Notification.create(notification_type: :new_event)
      expect(batcher.unsent_messages.values.flatten).to eq([notif])
      batcher.mark_sent([notif])
      expect(batcher.unsent_messages.values.flatten).to eq([])
    end
  end
end
