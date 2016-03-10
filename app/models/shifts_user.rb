class ShiftsUser < ApplicationRecord
  belongs_to :user
  belongs_to :shift, counter_cache: :volunteers_count
end
