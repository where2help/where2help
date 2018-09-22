class RemoveShiftLengthFromEvent < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :shift_length
  end
end
