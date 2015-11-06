class Volunteering < ActiveRecord::Base
  belongs_to :user
  belongs_to :need, counter_cache: true

   validates :user_id, uniqueness: {
     scope: :need_id,
     message: "Sie sind bereits als Helfer eingetragen."
   }
end
