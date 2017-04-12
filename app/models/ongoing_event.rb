class OngoingEvent < ApplicationRecord
  acts_as_paranoid

  belongs_to :ngo
  belongs_to :ongoing_event_category
  has_many   :participations, dependent: :destroy
  has_many   :users,          through:   :participations
  has_many   :notifications,  as:        :notifiable

  validates :title, length: { in: 1..100 }
  validates :address, presence: true
  validates :contact_person, presence: true
  validates :ongoing_event_category, presence: true

  scope :newest_first, -> { order(created_at: :desc) }
  scope :published,    -> { where.not(published_at: nil) }

  def pending?
    published_at.blank?
  end

  def state
    s = %w(deleted published).find { |state| send("#{state}?") }
    s || "pending"
  end

  def published?
    published_at.present?
  end

  def pending?
    published_at.blank?
  end

  def publish!
    update(published_at: Time.now) unless published?
  end

  def unpublish!
    update(published_at: nil)
  end

  def toggle_published!
    published? ? unpublish! : publish!
  end
end
