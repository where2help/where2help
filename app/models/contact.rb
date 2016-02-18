class Contact < ApplicationRecord
  belongs_to :ngo

  validates :first_name, length: { in: 1..50 }
  validates :last_name, length: { in: 1..50 }
  validates :email, presence: true
  validates :phone, presence: true
  validates :street, presence: true
  validates :zip, presence: true
  validates :city, presence: true
end
