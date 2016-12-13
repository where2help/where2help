class UserMailer < ApplicationMailer
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
end
