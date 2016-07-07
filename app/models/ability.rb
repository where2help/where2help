class Ability < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :qualifications, dependent: :destroy
  has_many :users, through: :qualifications
end
