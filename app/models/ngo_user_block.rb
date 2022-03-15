class NgoUserBlock < ApplicationRecord
  belongs_to :user
  belongs_to :ngo
end
