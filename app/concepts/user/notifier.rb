class User::Notifier
  class Upcoming
    WHEN_UPCOMING = -> { Time.now + 1.day }

    def self.call
      new.notify_upcoming!
    end

    class Worker < ApplicationJob
      def perform
        ActiveRecord::Base.connection_pool.with_connection do
          Upcoming.new.notify_upcoming!
        end
      end
    end

    def initialize
      @chatbot_cli = Chatbot::Client.new
    end

    def notify_upcoming!
      start  = Time.now
      ending = WHEN_UPCOMING.()
      upcoming_shifts = Shift.includes(:users, [notifications: :user]).where("starts_at > ? AND starts_at < ?", start, ending)
      upcoming_shifts.each do |s|
        handle_shift(s)
      end
    end

    private

    def handle_shift(shift)
      s_users = shift.users
      n_users = shift.notifications.map(&:user)
      users_to_notify = (s_users - n_users).uniq
      users_to_notify.each do |u|
        notify_upcoming(u, shift)
      end
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
        Rails.logger.info("Sending notification email to #{user.email}")
        was_notified = true
      end
      if was_notified
        shift.notifications.create(notified_at: Time.now, notification_type: :upcoming_event, user_id: user.id)
      end
    end
  end

  class New
    def self.call(event)
      Worker.perform_later(event)
    end

    class Worker < ApplicationJob
      def perform(event)
        ActiveRecord::Base.connection_pool.with_connection do
          New.new.notify_new!(event)
        end
      end
    end

    def initialize
      @chatbot_cli = Chatbot::Client.new
    end

    def notify_new!(event)
      nids = notified_user_ids(event)
      User.where.not(id: nids).each do |u|
        notify_new(u, event)
      end
    end

    private

    def notified_user_ids(event)
      event
        .notifications
        .includes(:user)
        .where(notification_type: :new_event)
        .map { |n| n.user.id }
    end

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
  end
end
