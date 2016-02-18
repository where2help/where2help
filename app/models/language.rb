class Language < ApplicationRecord
  has_many :languages_users
  has_many :users, through: :languages_users
  validates_presence_of :name
  validates_uniqueness_of :name
end
