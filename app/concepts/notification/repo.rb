class Notfication::Repo
  def unsent
    Notification.where(sent_at: nil)
  end

  def current_failed_messages
    Notification.includes(:account)
      .where(
        from_bot: true,
        sent_at:  nil
      )
      .where.not(
        last_send_attempt: nil
      )
  end

  def log_error(notification, body, time)
    debug("#log_error NOOP")
  end

  def log_sent(notification, time)
    debug("#log_sent NOOP")
  end

  def debug(msg)
    Rails.logger.debug("Notfication::Repo - #{msg.inspect}")
  end
end
