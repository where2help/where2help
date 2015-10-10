class Need < ActiveRecord::Base

  # associations
  has_many :volunteerings
  has_many :users, through: :volunteerings
end
