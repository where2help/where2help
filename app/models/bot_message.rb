class BotMessage < ApplicationRecord
  enum provider: {
    facebook: 10,
  }

  belongs_to :user
end
