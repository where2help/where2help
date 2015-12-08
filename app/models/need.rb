class Need < ActiveRecord::Base

  # scopes
  scope :upcoming, -> { where('start_time >= (?)', Time.now).order(:start_time) }
  scope :past, -> { where('start_time < (?)', Time.now).order(start_time: :desc) }
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
    return all unless category.present?
    where(category: Need.categories[category])
  end

  def self.filter_place(place)
    return all unless place.present?
    where('city @@ :q or location @@ :q', q: place)
  end

  def self.filter_scope(scope)
    send(scope)
  rescue NoMethodError
    puts 'IN RESCUE BLOCK'
    all
  end

  # instance methods
  def volunteers_needed?
    volunteerings.size < volunteers_needed
  end

  def i18n_category
    I18n.t(category, scope: [:activerecord, :attributes, :need, :categories])
  end

  def upcoming?
    start_time >= Time.now
  end
end
