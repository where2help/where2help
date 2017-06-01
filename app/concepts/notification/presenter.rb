class Notification::Presenter
  class Message < Struct.new(:text, :link)
    def to_message() text end
  end

  def present(notification)
    send(notification.notification_type, notification)
  end

  def new_event(notification)
    with_event_data(notification) { |event, user, link|
      msg = I18n.t("chatbot.events.new.text", title: event.title, locale: user.locale)
      Message.new(msg, link)
    }
  end

  def upcoming_event(notification)
    user       = notification.user
    shift      = notification.notifiable
    event      = shift.event
    event_link = make_event_link(event)
    msg = I18n.t("chatbot.shifts.upcoming.text",
                 title:           shift.event.title,
                 starts_at_date:  Notification::Utils.pretty_date(shift.starts_at),
                 starts_at_time:  Notification::Utils.pretty_time(shift.starts_at),
                 locale:          user.locale)
    Message.new(msg, event_link)
  end

  def updated_shift(notification)
    user       = notification.user
    shift      = notification.notifiable
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

  def updated_event(notification)
    with_event_data(notification) { |event, user, link|
      msg = I18n.t("chatbot.events.updated.text", title: event.title, locale: user.locale)
      Message.new(msg, link)
    }
  end

  private

  def with_event_data(notification)
    event      = notification.notifiable
    user       = notification.user
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
