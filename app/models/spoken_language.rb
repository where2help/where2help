# frozen_string_literal: true

class SpokenLanguage < ApplicationRecord
  belongs_to :user, inverse_of: :spoken_languages
  belongs_to :language, inverse_of: :spoken_languages
end
