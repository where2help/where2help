class AddAasmStateToNgos < ActiveRecord::Migration
  def self.up
    add_column :ngos, :aasm_state, :string
  end

  def self.down
    remove_column :ngos, :aasm_state
  end
end
