class RemoveAasmFromNgo < ActiveRecord::Migration[5.0]
  def change
    remove_column :ngos, :aasm_state, :string
  end
end
