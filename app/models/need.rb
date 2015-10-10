class Need < ActiveRecord::Base

  enum category: {legal: 0, general: 1, medical: 2, translation: 3}

  # associations
  has_many :volunteerings
  has_many :users, through: :volunteerings
end
