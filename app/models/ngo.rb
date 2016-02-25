class Ngo < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  has_one :contact, dependent: :destroy, inverse_of: :ngo
  accepts_nested_attributes_for :contact, reject_if: :all_blank

  validates :name, presence: true
  validates :identifier, presence: true
  validates_presence_of :contact
end
