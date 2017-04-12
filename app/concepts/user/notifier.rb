class User::Notifier
  WHEN_UPCOMING = -> { Time.now + 1.day }

  def initialize
    @chatbot_cli = Chatbot::Client.new
  end

  def notify_upcoming!
    # Look for upcoming events
    start = Time.now
    ending = WHEN_UPCOMING.()
    shifts = Shift.includes(:users, [notifications: :user]).where("starts_at > ? AND starts_at < ?", start, ending)
    # Find which users haven't been notified
    shifts.each do |s|
      s_users = s.users
      n_users = s.notifications.map(&:user)
      users_to_notify = (s_users - n_users).uniq
      users_to_notify.each do |u|
        notify_upcoming(u, s)
      end
    end
  end

  # We are assuming:
  #
  # 1. this can only be run once
  # 2. We notify all the users because we don't have any categories
  #
  def notify_new!(event)
    User.find_each do |u|
      notify_new(u, event)
    end
  end

  private

  def notify_new(user, event)
    settings = User::Settings.new(user)
    return unless settings.can_notify_new_event?
    was_notified = false
    if settings.can_notify_facebook?
      msg = "There is a new event you may be interested in. Check out the event #{event.title} at #{make_event_link(event)}."
      @chatbot_cli.send_text(user, msg)
      was_notified = true
    end

    if settings.can_notify_email?
      Rails.logger.debug("Sending notification email to #{user.email}")
      was_notified = true
    end

    if was_notified
      event.notifications.create(notified_at: Time.now, notification_type: :new_event, user_id: user.id)
    end
  end

  def make_event_link(event)
    resource =
      case event
        when OngoingEvent
          "ongoing_events"
        else
          "events"
      end
    "https://where2help.wien/#{resource}/#{event.id}"
  end

  def notify_upcoming(user, shift)
    settings = User::Settings.new(user)
    return unless settings.can_notify_upcoming_event?
    was_notified = false
    if settings.can_notify_facebook?
      msg = "The shift for #{shift.event.title} is starting #{shift.starts_at}. See you then!"
      @chatbot_cli.send_text(user, msg)
      was_notified = true
    end
    if settings.can_notify_email?
      Rails.logger.debug("Sending notification email to #{user.email}")
      was_notified = true
    end
    if was_notified
      shift.notifications.create(notified_at: Time.now, notification_type: :upcoming_event, user_id: user.id)
    end
  end

end
