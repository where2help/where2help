require "rails_helper"

require "user/notifier/upcoming"

describe User::Notifier::Upcoming do
  it "notifies signed up users of upcoming shift" do
    user_count = 3
    users = 1.upto(user_count).map {
      user = create(:user)
      User::Settings.new(user).setup_new_user!
      user
    }
    shift = create(:shift, :with_event)
    user = users.first
    shift.users << user
    ngo = create(:ngo)
    create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::Upcoming.new
    expect {
      n.notify!
    }.to change(Notification, :count).by(1)
    expect(Notification.first.user).to eq(user)
  end

  it "doesn't notify same user twice" do
    user_count = 3
    users = 1.upto(user_count).map {
      user = create(:user)
      User::Settings.new(user).setup_new_user!
      user
    }
    shift = create(:shift, :with_event)
    user = users.first
    shift.users << user
    ngo   = create(:ngo)
    create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::Upcoming.new
    n.notify!
    n.notify!
    expect(Notification.count).to eq(1)
  end

  it "doesn't notify when user has notifications turned off" do
    user = create(:user)
    settings = User::Settings.new(user)
    settings.update(
      User::Settings::FB_NOTIFICATION_KEY    => false,
      User::Settings::EMAIL_NOTIFICATION_KEY => false,
      User::Settings::UPCOMING_EVENT_KEY     => true)
    shift = create(:shift, :with_event)
    shift.users << user
    ngo   = create(:ngo)
    event = create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::Upcoming.new
    expect(n.chatbot_cli).not_to receive(:send_text).with(user, instance_of(String))
    expect(UserMailer).not_to receive(:upcoming_event).with(user: user, event: event)
    n.notify!
  end
end

