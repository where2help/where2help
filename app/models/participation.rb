class Participation < ApplicationRecord
  acts_as_paranoid

  belongs_to :user, inverse_of: :participations
  belongs_to :shift,         counter_cache: :volunteers_count, optional: true, inverse_of: :participations
  belongs_to :ongoing_event, counter_cache: :volunteers_count, optional: true, inverse_of: :participations

  # unless is used because we should be using polymorphic
  # So if it is for shifts, don't care if ongoing_event_id is nil and vice versa
  validates :user_id, uniqueness: { scope: :shift_id,
                                    message: "Sie haben schon zugesagt!" },
                      unless: ->(p) { p.shift_id.nil? }

  validates :user_id, uniqueness: { scope: :ongoing_event_id,
                                    message: "Sie haben schon zugesagt!" },
                      unless: ->(p) { p.ongoing_event_id.nil? }
end
