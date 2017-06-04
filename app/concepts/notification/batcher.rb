class Notification::Batcher
  def self.call
    new.start
  end

  def start
    user_notifications =
      unsent_messages
        .map { |_k, user_notifs|
          filter_notifications(user_notifs)
        }
    notification_templates =
      user_notifications
        .map { |user_notifs|
          present_notifications(user_notifs)
        }
    notification_templates.each do |template|
      send_notification(template)
    end
  end

  def unsent_messages
    Notification::Repo.new.unsent
      .to_a
      .group_by { |n| n.user_id }
  end

  def filter_notifications(notifs)
    return [] if notifs.empty?
    user = User::Settings.new(notifs.first.user)
    notifs.each_with_object([]) { |notif, valid_notifs|
      case notif.notification_type.to_sym
      when :new_event
        valid_notifs << notif if user.can_notify_new_event?
      when :upcoming_event
        valid_notifs << notif if user.can_notify_upcoming_event?
      when :updated_event, :updated_shift
        valid_notifs << notif if user.can_notify_updated_event?
      end
    }
  end

  def present_notifications(notifs)
    return nil if notifs.empty?
    user = notifs.first.user
    Notification::Presenter.present_batch(notifs, user)
  end

  def send_notification(template)
    return nil if template.nil?
    permissions = User::Settings.new(template.user)
    if permissions.can_notify_facebook?
      ChatbotOperation::BatchNotification.(template)
    end
    if permissions.can_notify_email?
      send_emails(template)
    end
    if permissions.can_notify_facebook? || permissions.can_notify_email?
      mark_sent(template.notifications, Time.now)
    end
    template.notifications
  end

  def mark_sent(notifications, at = Time.now)
    notifications.each do |n|
      n.update_attributes(sent_at: at)
    end
  end

  def send_emails(template)
    UserMailer.batch_notifications(
      user: template.user,
      notifications: template.parts.map(&:to_h),
    ).deliver_later
  end
end
