class BotMessage < ApplicationRecord
  belongs_to :account, class_name: "FacebookAccount", foreign_key: :account_id
end
