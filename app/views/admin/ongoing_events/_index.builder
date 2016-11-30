context.instance_eval do
  selectable_column
  id_column
  column :ngo
  column :title
  column :address
  column :contact_person
  column :volunteers_needed
  column(:state){ |ngo| status_tag(Event.human_attribute_name("state-#{ngo.state}")) }
  column :created_at
  column :published_at
  column :deleted_at
  actions
end
