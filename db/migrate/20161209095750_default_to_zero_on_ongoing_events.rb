class DefaultToZeroOnOngoingEvents < ActiveRecord::Migration[5.0]
  def change
    change_column :ongoing_events, :volunteers_count, :integer, default: 0
  end
end
