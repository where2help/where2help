context.instance_eval do
  selectable_column
  id_column
  column :name
  column :email
  column :locale
  column(:state){ |ngo| status_tag(Ngo.human_attribute_name("state-#{ngo.state}")) }
  actions
end
