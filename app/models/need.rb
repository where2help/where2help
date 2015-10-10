class Need < ActiveRecord::Base

  # scopes  
  #scope :required, -> { where() }

  enum category: {general: 0, legal: 1, medical: 2, translation: 3}

  # associations
  has_many :volunteerings
  belongs_to :user

  # validations
  #validates 

  # class methods
  def self.categories_for_select
    categories.map do |t|
      [I18n.t(t[0], scope: [:activerecord, :attributes, :need, :categories]), t[0]]
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
