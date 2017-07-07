class User::Settings
  FB_NOTIFICATION_KEY    = "allow_facebook_notifications"
  EMAIL_NOTIFICATION_KEY = "allow_email_notifications"
  NEW_EVENT_KEY          = "notify_new_events"
  UPCOMING_EVENT_KEY     = "notify_upcoming_events"
  UPDATED_EVENT_KEY      = "notify_updated_events"

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def setup_new_user!
    initialize_reference_id!
  end

  def initialize_reference_id!
    user.update_attributes(facebook_reference_id: generate_uuid)
  end

  def update(params)
    settings = params.slice(
      FB_NOTIFICATION_KEY,
      EMAIL_NOTIFICATION_KEY,
      NEW_EVENT_KEY,
      UPCOMING_EVENT_KEY,
      UPDATED_EVENT_KEY
    )
    parse_trues(settings)
    # I don't want to have to type check the params. Could be a hash, could be a ActionController::Parameters
    # So we'll treat it like a hash and it will always work.
    params = ActionController::Parameters.new(settings)
    user.update_attributes(params.permit(*settings.keys))
    user
  end

  def parse_trues(settings)
    [ FB_NOTIFICATION_KEY,
      EMAIL_NOTIFICATION_KEY,
      NEW_EVENT_KEY,
      UPCOMING_EVENT_KEY,
      UPDATED_EVENT_KEY
    ].each do |k|
        setting = settings[k]
        is_set = !!setting
        settings[k] = is_set ? true : false
      end
  end

  def can_notify_facebook?
    !!user.send(FB_NOTIFICATION_KEY)
  end

  def can_notify_email?
    !!user.send(EMAIL_NOTIFICATION_KEY)
  end

  def can_notify_new_event?
    !!user.send(NEW_EVENT_KEY)
  end

  def can_notify_upcoming_event?
    !!user.send(UPCOMING_EVENT_KEY)
  end

  def can_notify_updated_event?
    !!user.send(UPDATED_EVENT_KEY)
  end

  private

  def generate_uuid
    loop do
      uuid = SecureRandom.uuid
      # make sure uuid is unique
      if User.find_by(facebook_reference_id: uuid).nil?
        return uuid
      end
    end
  end
end
