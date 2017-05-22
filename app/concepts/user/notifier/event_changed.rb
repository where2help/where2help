module User::Notifier
  class EventChanged
    def self.call(event:)
      uniq_users(event).each do |user|
        Worker.perform_later(user, event)
      end
    end

    def self.uniq_users(event)
      event.shifts.flat_map(&:users).uniq
    end

    class Worker < ApplicationJob
      def perform(user, event)
        ActiveRecord::Base.connection_pool.with_connection do
          EventChanged.new.notify!(user, event)
        end
      end
    end

    def initialize
      @cli = Chatbot::Client.new
    end

    def notify!(user, event)
      settings = User::Settings.new(user)
      return unless settings.can_notify_updated_event?
      was_notified = false
      if settings.can_notify_facebook?
        send_bot_message(event, user)
        was_notified = true
      end

      if settings.can_notify_email?
        send_mail(event, user)
        was_notified = true
      end

      if was_notified
        event.notifications.create(notified_at: Time.now, notification_type: :updated_event, user_id: user.id)
      end
    end

    def send_bot_message(event, user)
      event_link = make_event_link(event)
      msg        = I18n.t("chatbot.events.updated.text", title: event.title, link: event_link, locale: user.locale)
      btn_text   = I18n.t("chatbot.events.updated.button_text")
      button     = MessengerClient::URLButton.new(btn_text, event_link)
      chatbot_cli.send_button_template(user, msg, [button])
    end

    def send_mail(event, user)
      case event
      when OngoingEvent
        UserMailer.ongoing_event_updated(event: event, user: user).deliver_later
      else
        UserMailer.event_updated(event: event, user: user).deliver_later
      end
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
end
