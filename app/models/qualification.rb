# frozen_string_literal: true

class Qualification < ApplicationRecord
  belongs_to :user, inverse_of: :qualifications
  belongs_to :ability, inverse_of: :qualifications
end
