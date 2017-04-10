class User::Settings
  FB_NOTIFICATION_KEY    = "allow_facebook_notfications"
  EMAIL_NOTIFICATION_KEY = "allow_facebook_notfications"

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def can_notify_facebook?
    fb = user.setting(FB_NOTIFICATION_KEY)
    fb == true
  end

  def can_notify_email?
    email = user.setting(EMAIL_NOTIFICATION_KEY)
    email.nil? || email == true
  end

  def allow_facebook!
    user.add_setting(FB_NOTIFICATION_KEY, true)
  end

  def allow_email!
    user.add_setting(EMAIL_NOTIFICATION_KEY, true)
  end

  def deny_facebook!
    user.add_setting(FB_NOTIFICATION_KEY, false)
  end

  def deny_email!
    user.add_setting(EMAIL_NOTIFICATION_KEY, false)
  end
end
