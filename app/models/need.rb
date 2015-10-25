class Need < ActiveRecord::Base

  # scopes
  scope :upcoming, -> { where('start_time >= (?)', Time.now).order(:start_time) }
  scope :unfulfilled, -> { where('volunteerings_count < volunteers_needed') }
  scope :fulfilled, -> { where('volunteerings_count >= volunteers_needed') }

  # macros
  enum category: { general: 0, legal: 1, medical: 2, translation: 3 }

  # associations
  has_many :volunteerings
  has_many :volunteers, through: :volunteerings, source: :user
  belongs_to :user

  # validations

  # class methods
  def self.categories_for_select
    categories.map do |t|
      [I18n.t(t[0], scope: [:activerecord, :attributes, :need, :categories]), t[0]]
    end
  end

  def self.filter_category(category)
    if category.present?
      where(category: Need.categories[category])
    else
      all
    end
  end

  def self.filter_place(place)
    if place.present?
      where('city @@ :q or location @@ :q', q: place)
    else
      all
    end
  end

  # instance methods
  def volunteers_needed?
    volunteerings.size < volunteers_needed
  end

  def i18n_category
    I18n.t(category, scope: [:activerecord, :attributes, :need, :categories])
  end
end
