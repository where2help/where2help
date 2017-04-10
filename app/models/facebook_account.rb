require "securerandom"

class FacebookAccount < ApplicationRecord
  belongs_to :user

  def generate_uuid!
    loop do
      uuid       = SecureRandom.uuid
      acct = FacebookAccount.find_by(referencing_id: uuid)
      if acct.nil?
        update_attribute(:referencing_id, uuid)
        break
      else
        next
      end
    end
    self
  end
end
