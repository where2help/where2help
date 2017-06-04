class UserMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper
  def shift_destroyed(shift, user)
    @shift = shift
    @user = user
    I18n.with_locale(@user.locale) do
      mail.to(@user.email)
    end
  end

  def shift_updated(shift, user)
    @shift = shift
    @user = user
    I18n.with_locale(@user.locale) do
      mail.to(@user.email)
    end
  end

  def ongoing_event_destroyed(event:, user:)
    @user  = user
    @event = event
    I18n.with_locale(@user.locale) do
      mail.to(@user.email)
    end
  end

  def ongoing_event_updated(event:, user:)
    @user  = user
    @event = event
    I18n.with_locale(@user.locale) do
      mail.to(@user.email)
    end
  end

  def event_updated(event:, user:)
    @user  = user
    @event = event
    I18n.with_locale(@user.locale) do
      mail.to(@user.email)
    end
  end

  def new_event(event:, user:)
    @user  = user
    @event = event
    @link  = case @event
      when Event        then events_url(@event)
      when OngoingEvent then ongoing_events_url(@event)
    end
    I18n.with_locale(@user.locale) do
      mail.to(@user.email)
    end
  end

  def upcoming_event(shift:, user:)
    @user  = user
    @shift = shift
    @link  = events_url(@shift.event)
    I18n.with_locale(@user.locale) do
      mail.to(@user.email)
    end
  end

  def batch_notifications(user:, notifications:)
    @user          = user
    @count         = notifications.size
    @locale        = user.locale
    @notifications = notifications.map { |n| OpenStruct.new(n)}
    I18n.with_locale(@locale) do
      @updates_text = pluralize(
        @count,
        I18n.t("user_mailer.batch_notifications.update"),
        I18n.t("user_mailer.batch_notifications.updates"))
      mail.to(@user.email)
    end
  end
end
