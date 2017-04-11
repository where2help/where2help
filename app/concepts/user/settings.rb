class User::Settings
  FB_NOTIFICATION_KEY    = "allow_facebook_notfications"
  EMAIL_NOTIFICATION_KEY = "allow_email_notfications"
  NEW_EVENT_KEY          = "notify_new_events"
  UPCOMING_EVENT_KEY     = "notify_upcoming_events"

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def setup_new_user!
    settings = {
      FB_NOTIFICATION_KEY    => false,
      EMAIL_NOTIFICATION_KEY => true,
      NEW_EVENT_KEY          => true,
      UPCOMING_EVENT_KEY     => true,
    }
    user.update_attribute(:settings, settings)
  end

  def update(params)
    user.update_attribute(:settings, params)
  end

  def can_notify_facebook?
    !!user.setting(FB_NOTIFICATION_KEY)
  end

  def can_notify_email?
    !!user.setting(EMAIL_NOTIFICATION_KEY)
  end

  def can_notify_new_event?
    !!user.setting(NEW_EVENT_KEY)
  end

  def can_notify_upcoming_event?
    !!user.setting(UPCOMING_EVENT_KEY)
  end
end
