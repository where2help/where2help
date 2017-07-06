class AddRenewedAtToOngoingEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :ongoing_events, :renewed_at, :datetime
  end
end
