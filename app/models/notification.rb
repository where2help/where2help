class Notification < ApplicationRecord
  enum type: {
    new_event: 10,
    upcoming_event: 30,
  }

  belongs_to :user
  belongs_to :shift, polymorphic: true
end
