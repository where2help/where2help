class Participation < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :user
  belongs_to :shift, counter_cache: :volunteers_count

  validates :user_id, uniqueness: { scope: :shift_id,
                                    message: "Sie haben schon zugesagt!" }
end
