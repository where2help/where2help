class Language < ApplicationRecord
  has_many :languages_users, dependent: :destroy
  has_many :users, through: :languages_users
  validates_presence_of :name
  validates_uniqueness_of :name
end
