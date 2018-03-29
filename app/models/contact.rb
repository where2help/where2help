class Contact < ApplicationRecord
  acts_as_paranoid without_default_scope: true

  belongs_to :ngo, inverse_of: :contact

  validates :first_name, length: { in: 1..50 }
  validates :last_name, length: { in: 1..50 }
  validates :email, presence: true
  validates :phone, presence: true
  validates :street, presence: true
  validates :zip, presence: true
  validates :city, presence: true
end
