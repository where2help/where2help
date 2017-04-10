require "securerandom"

class FacebookAccount < ApplicationRecord
  belongs_to :user
  has_many   :bot_messages, foreign_key: :account_id

  def generate_uuid!
    loop do
      uuid = SecureRandom.uuid
      # make sure uuid is unique
      acct = FacebookAccount.find_by(referencing_id: uuid)
      if acct.nil?
        update_attribute(:referencing_id, uuid)
        return self
      end
    end
  end
end
