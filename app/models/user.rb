class User < ApplicationRecord
  acts_as_paranoid
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :confirmable, :validatable,
    :lockable

  enum locale: { de: 0, en: 1 }

  has_secure_token :api_token

  has_many :spoken_languages, dependent: :destroy, inverse_of: :user
  has_many :languages, through: :spoken_languages
  has_many :qualifications, dependent: :destroy, inverse_of: :user
  has_many :abilities, through: :qualifications

  has_many :participations, dependent: :destroy, inverse_of: :user
  has_many :shifts,         through: :participations
  has_many :ongoing_events, through: :participations

  validates :first_name, length: { in: 1..50 }
  validates :last_name, length: { in: 1..50 }
  validates :terms_and_conditions, acceptance: true

  accepts_nested_attributes_for :abilities, :languages

  def locked?
    access_locked?
  end
end
