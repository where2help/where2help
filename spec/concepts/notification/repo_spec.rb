require "rails_helper"

describe Notification::Repo do
  let(:user) { create(:user) }
  let(:notifiable) { create(:ongoing_event) }

  context "#unsent" do
    it "returns unsent notifications" do
      notif = user.notifications.create!(notifiable: notifiable)
      notifs = Notification::Repo.new.unsent
      expect(notifs.first).to eq(notif)
    end

    it "doesn't return sent notifications" do
      user.notifications.create!(sent_at: Time.now, notifiable: notifiable)
      notifs = Notification::Repo.new.unsent
      expect(notifs.size).to eq(0)
    end
  end
end
