class User::Settings
  FB_NOTIFICATION_KEY    = "allow_facebook_notifications"
  EMAIL_NOTIFICATION_KEY = "allow_email_notifications"
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
    create_facebook_account
  end

  def update(params)
    settings = params.slice(
      FB_NOTIFICATION_KEY,
      EMAIL_NOTIFICATION_KEY,
      NEW_EVENT_KEY,
      UPCOMING_EVENT_KEY
    )
    parse_trues(settings)
    user.update_attribute(:settings, settings)
  end

  def parse_trues(settings)
    [ FB_NOTIFICATION_KEY,
      EMAIL_NOTIFICATION_KEY,
      NEW_EVENT_KEY,
      UPCOMING_EVENT_KEY ]
      .each do |k|
        settings[k] = settings[k].nil? ? false : true
      end
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

  private

  def create_facebook_account
    acct = user.create_facebook_account
    acct.generate_uuid!
  end
end
