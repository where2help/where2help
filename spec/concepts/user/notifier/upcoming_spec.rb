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
    shift = create(:shift)
    user = users.first
    shift.users << user
    ngo   = create(:ngo)
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
    shift = create(:shift)
    user = users.first
    shift.users << user
    ngo   = create(:ngo)
    create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::Upcoming.new
    n.notify!
    n.notify!
    expect(Notification.count).to eq(1)
  end

  it "notifies by facebook" do
    user = create(:user)
    settings = User::Settings.new(user)
    settings.update(User::Settings::FB_NOTIFICATION_KEY => true, User::Settings::UPCOMING_EVENT_KEY => true)

    shift = create(:shift)
    shift.users << user
    ngo   = create(:ngo)
    create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::Upcoming.new
    expect(n.chatbot_cli).to receive(:send_text).with(user, instance_of(String))
    n.notify!
  end

  it "notifies by email" do
    user = create(:user)
    settings = User::Settings.new(user)
    settings.setup_new_user!

    shift = create(:shift)
    shift.users << user
    ngo   = create(:ngo)
    event = create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::Upcoming.new
    expect(UserMailer).to receive(:upcoming_event).with(user: user, shift: shift).and_return(Struct.new(:deliver_later).new(nil))
    n.notify!
  end

  it "doesn't notify when user has notifications turned off" do
    user = create(:user)
    settings = User::Settings.new(user)
    settings.update(
      User::Settings::FB_NOTIFICATION_KEY    => false,
      User::Settings::EMAIL_NOTIFICATION_KEY => false,
      User::Settings::UPCOMING_EVENT_KEY          => true)
    shift = create(:shift)
    shift.users << user
    ngo   = create(:ngo)
    event = create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::Upcoming.new
    expect(n.chatbot_cli).not_to receive(:send_text).with(user, instance_of(String))
    expect(UserMailer).not_to receive(:upcoming_event).with(user: user, event: event)
    n.notify!
  end
end

