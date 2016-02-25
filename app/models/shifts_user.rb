class ShiftsUser < ApplicationRecord
  belongs_to :user
  belongs_to :shift
end
