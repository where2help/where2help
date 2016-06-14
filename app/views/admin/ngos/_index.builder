context.instance_eval do
  selectable_column
  id_column
  column :name
  column :email
  column :locale
  column(:aasm_state){ |ngo| status_tag(ngo.aasm.human_state) }
  actions
end
