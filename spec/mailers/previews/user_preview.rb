# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def shift_destroyed
    UserMailer.shift_destroyed(Shift.first, User.first)
  end

  def shift_updated
    UserMailer.shift_updated(Shift.first, User.first)
  end

  def ongoing_event_destroyed
    UserMailer.ongoing_event_destroyed(event: OngoingEvent.first, user: User.first)
  end

  def ongoing_event_updated
    UserMailer.ongoing_event_updated(event: OngoingEvent.first, user: User.first)
  end

  def event_updated
    UserMailer.event_updated(event: Event.first, user: User.first)
  end
end
