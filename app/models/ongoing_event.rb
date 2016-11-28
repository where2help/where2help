class OngoingEvent < ApplicationRecord
  acts_as_paranoid

  belongs_to :ngo

  scope :newest_first, -> { order(:created_at) }

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
