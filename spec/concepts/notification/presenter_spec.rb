require "rails_helper"

describe Notification::Presenter do
  it "creates a template for my notification" do
    user = create(:user)
    event = create(:event, :with_shift)
    notif = user.notifications.create(notification_type: :new_event, notifiable: event)
    template = Notification::Presenter.present_batch([notif], user)
    parts = template.parts
    url = Rails.application.routes.url_helpers.event_url(event)
    expect(parts.first.url).to eq(url)
    expect(parts.first.text).to eq(I18n.t("chatbot.events.new.text", title: event.title, locale: user.locale))
    expect(parts.size).to eq(1)
  end
end
