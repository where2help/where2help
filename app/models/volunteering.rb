class Volunteering < ActiveRecord::Base
  belongs_to :user
  belongs_to :need, counter_cache: true
end
