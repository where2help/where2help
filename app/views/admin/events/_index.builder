context.instance_eval do
  selectable_column
  id_column
  column :ngo
  column :title
  column :address
  column(:state){ |event| status_tag(event.aasm.human_state) }
  actions
end
