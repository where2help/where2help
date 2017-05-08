module User::Notifier
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
        send_bot_message(event, user)
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

    def send_bot_message(event, user)
      event_link = make_event_link(event)
      msg        = I18n.t("chatbot.events.new.text", title: event.title, link: event_link, locale: user.locale)
      btn_text   = I18n.t("chatbot.events.new.button_text")
      button     = MessengerClient::URLButton.new(btn_text, event_link)
      chatbot_cli.send_button_template(user, msg, [button])
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
