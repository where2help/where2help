require "rails_helper"

require "user/notifier/new"

describe User::Notifier::New do
  it "notifies all users of new event" do
    user_count = 3
    users = 1.upto(user_count).map {
      user = create(:user)
      User::Settings.new(user).setup_new_user!
      user
    }
    shift = create(:shift)
    shift.users << users.first
    ngo   = create(:ngo)
    event = create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::New.new
    expect {
      n.notify!(event)
    }.to change(Notification, :count).by(user_count)
  end

  it "doesn't notify same user twice" do
    user_count = 3
    users = 1.upto(user_count).map {
      user = create(:user)
      User::Settings.new(user).setup_new_user!
      user
    }
    shift = create(:shift)
    shift.users << users.first
    ngo   = create(:ngo)
    event = create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::New.new
    n.notify!(event)
    n.notify!(event)
    expect(Notification.count).to eq(user_count)
  end

  it "notifies by facebook" do
    user = create(:user)
    settings = User::Settings.new(user)
    settings.update(User::Settings::FB_NOTIFICATION_KEY => true, User::Settings::NEW_EVENT_KEY => true)

    shift = create(:shift)
    shift.users << user
    ngo   = create(:ngo)
    event = create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::New.new
    expect(n.chatbot_cli).to receive(:send_text).with(user, instance_of(String))
    n.notify!(event)
  end

  it "notifies by email" do
    user = create(:user)
    settings = User::Settings.new(user)
    settings.setup_new_user!

    shift = create(:shift)
    shift.users << user
    ngo   = create(:ngo)
    event = create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::New.new
    expect(UserMailer).to receive(:new_event).with(user: user, event: event).and_return(Struct.new(:deliver_later).new(nil))
    n.notify!(event)
  end

  it "doesn't notify when user has notifications turned off" do
    user = create(:user)
    settings = User::Settings.new(user)
    settings.update(
      User::Settings::FB_NOTIFICATION_KEY    => false,
      User::Settings::EMAIL_NOTIFICATION_KEY => false,
      User::Settings::NEW_EVENT_KEY          => true)
    shift = create(:shift)
    shift.users << user
    ngo   = create(:ngo)
    event = create(:event, ngo: ngo, shifts: [shift])

    n = User::Notifier::New.new
    expect(n.chatbot_cli).not_to receive(:send_text).with(user, instance_of(String))
    expect(UserMailer).not_to receive(:new_event).with(user: user, event: event)
    n.notify!(event)
  end
end
