class AbilitiesUser < ApplicationRecord
  belongs_to :user
  belongs_to :ability
end
