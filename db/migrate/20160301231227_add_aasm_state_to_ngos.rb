class AddAasmStateToNgos < ActiveRecord::Migration[5.0]
  def self.up
    add_column :ngos, :aasm_state, :string
  end

  def self.down
    remove_column :ngos, :aasm_state
  end
end
