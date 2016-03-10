class Shift < ApplicationRecord
  has_many :shifts_users
  has_many :users, through: :shifts_users
  belongs_to :event
  validates :volunteers_needed, :starts_at, :ends_at, presence: true

  def current_user_assigned?
    users.includes?(current_user) if current_user
  end
end
