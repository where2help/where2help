context.instance_eval do
  selectable_column
  id_column
  column :name
  column :identifier
  column :email
  column :locale
  column :confirmed_at
  column(:aasm_state){ |ngo| status_tag(ngo.aasm.current_state) }
  actions
end
