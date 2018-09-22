class OngoingEventCategory < ApplicationRecord
  validates :name_en, :name_de,
            presence: true,
            uniqueness: true

  has_many :ongoing_events, dependent: :restrict_with_error, inverse_of: :ongoing_event_category

  scope :ordered, -> { order(ordinal: :asc) }

  def name
    case I18n.locale
    when :de
      name_de
    else # :en
      name_en
    end
  end
end
