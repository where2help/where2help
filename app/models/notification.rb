class Notification < ApplicationRecord
  enum notification_type: {
    new_event: 10,
    upcoming_event: 30,
    updated_event: 50,
    updated_shift: 70,
  }

  belongs_to :user, inverse_of: :notifications
  belongs_to :notifiable, polymorphic: true, inverse_of: :notifications
end
