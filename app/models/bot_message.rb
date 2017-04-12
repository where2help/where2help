class BotMessage < ApplicationRecord
  enum provider: {
    facebook: 10,
  }

  belongs_to :account, class_name: "FacebookAccount", foreign_key: :account_id
end
