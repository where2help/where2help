class Notification::Batcher
  def self.call
    new.start
  end

  def start
    unsent_messages
      .map { |_k, user_notifs|
        present_notifications(user_notifs)
      }
      .map { |presenter|
        send_notification(presenter)
      }
      .map { |notifications|
        mark_sent(notifications)
      }
  end

  def unsent_messages
    Notification::Repo.new.unsent
      .to_a
      .group_by { |n| n.user_id }
  end

  def present_notifications(notifs)
    Notification::Presenter.present_batch(notifs)
  end

  def send_notification(message_template)
    message_template.notifications
  end

  def mark_sent(notifications)
    notfication.each do |n|
      now = Time.now
      n.update_attributes(sent_at: now)
    end
  end
end
