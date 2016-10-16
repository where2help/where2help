class Contact < ApplicationRecord
  acts_as_paranoid without_default_scope: true

  belongs_to :ngo

  validates :first_name, length: { in: 1..50 }, on: :create
  validates :last_name, length: { in: 1..50 }, on: :create
  validates :email, presence: true, on: :create
  validates :phone, presence: true, on: :create
  validates :street, presence: true, on: :create
  validates :zip, presence: true, on: :create
  validates :city, presence: true, on: :create
end
