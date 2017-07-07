require "rails_helper"

describe Notification::Repo do
  context "#unsent" do
    it "returns unsent notifications" do
      user = create(:user)
      notif = user.notifications.create()
      notifs = Notification::Repo.new.unsent
      expect(notifs.first).to eq(notif)
    end

    it "doesn't return sent notifications" do
      user = create(:user)
      user.notifications.create(sent_at: Time.now)
      notifs = Notification::Repo.new.unsent
      expect(notifs.size).to eq(0)
    end
  end
end
