class Ability < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :abilities_users
  has_many :users, through: :abilities_users
end
