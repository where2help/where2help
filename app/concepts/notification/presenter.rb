class Notification::Presenter
  class Message < Struct.new(:text, :url)
    def to_message() text end
  end

  MessageTemplate = Struct.new(:header, :parts, :next_button, :locale, :notifications)
  NextButton      = Struct.new(:url, :text)

  def self.present_batch(notifications, locale)
    count  = notifications.size
    hd     = header(count, locale)
    parts  = notifications.map { |notif| new(notif).present }
    button = next_button(locale)
    MessageTemplate.new(hd, parts, button, locale, notifications)
  end

  def self.header(count, locale)
    I18n.t("chatbot.notifications.header", count: count, locale: locale)
  end

  def self.next_button(locale)
    url  = Rails.application.routes.url_helpers.events_url
    text = I18n.t("chatbot.notifications.button_text", locale: locale)
    NextButton.new(url, text)
  end

  def initialize(notification)
    @notification = notification
  end

  def present
    send(@notification.notification_type)
  end

  def new_event
    with_event_data { |event, user, link|
      msg = I18n.t("chatbot.events.new.text", title: event.title, locale: user.locale)
      Message.new(msg, link)
    }
  end

  def upcoming_event
    user       = @notification.user
    shift      = @notification.notifiable
    event      = shift.event
    event_link = make_event_link(event)
    msg = I18n.t("chatbot.shifts.upcoming.text",
                 title:           shift.event.title,
                 starts_at_date:  Notification::Utils.pretty_date(shift.starts_at),
                 starts_at_time:  Notification::Utils.pretty_time(shift.starts_at),
                 locale:          user.locale)
    Message.new(msg, event_link)
  end

  def updated_shift
    user       = @notification.user
    shift      = @notification.notifiable
    event      = shift.event
    event_link = make_event_link(event)
    msg        = I18n.t("chatbot.shifts.updated.text",
                        title:      event.title,
                        date:       Notification::Utils.pretty_date(shift.starts_at),
                        starts_at:  Notification::Utils.pretty_time(shift.starts_at),
                        ends_at:    Notification::Utils.pretty_time(shift.ends_at),
                        locale:     user.locale)
    Message.new(msg, event_link)
  end

  def updated_event
    with_event_data { |event, user, link|
      msg = I18n.t("chatbot.events.updated.text", title: event.title, locale: user.locale)
      Message.new(msg, link)
    }
  end

  private

  def with_event_data
    event      = @notification.notifiable
    user       = @notification.user
    event_link = make_event_link(event)
    yield(event, user, event_link)
  end

  def make_event_link(event)
    case event
      when OngoingEvent
        Rails.application.routes.url_helpers.ongoing_event_url(event)
      else
        Rails.application.routes.url_helpers.event_url(event)
    end
  end
end
