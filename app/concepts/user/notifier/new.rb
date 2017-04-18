class User::Notifier
  class New
    def self.call(event)
      Worker.perform_later(event)
    end

    class Worker < ApplicationJob
      def perform(event)
        ActiveRecord::Base.connection_pool.with_connection do
          New.new.notify!(event)
        end
      end
    end

    attr_reader :chatbot_cli

    def initialize
      @chatbot_cli = Chatbot::Client.new
    end

    def notify!(event)
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
        msg = I18n.t("chatbot.events.new", title: event.title, link: make_event_link(event), locale: user.locale)
        chatbot_cli.send_text(user, msg)
        was_notified = true
      end

      if settings.can_notify_email?
        UserMailer.new_event(user: user, event: event).deliver_later
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
