class Need < ActiveRecord::Base

  enum category: {legal: 0, general: 1, medical: 2, translation: 3}

  # associations
  has_many :volunteerings
  belongs_to :user

  # class methods
  def self.categories_for_select
    categories.map do |t|
      [I18n.t(t[0], scope: [:activerecord, :attributes, :need, :categories]), t[0]]
    end
  end
end
