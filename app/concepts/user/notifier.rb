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
        notify(u, s)
      end
    end
  end

  def notify(user, shift)
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
