class Language < ApplicationRecord
  has_many :spoken_languages, dependent: :destroy
  has_many :users, through: :spoken_languages
  validates_presence_of :name
  validates_uniqueness_of :name
end
