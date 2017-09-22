class AddNotifiedOfExpiryAtToOngoingEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :ongoing_events, :notified_of_expiry_at, :datetime
  end
end
