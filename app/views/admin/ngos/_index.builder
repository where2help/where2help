context.instance_eval do
  selectable_column
  id_column
  column :name
  column :identifier
  column :email
  column :locale
  column :confirmed_at
  column :admin_confirmed_at
  actions
end
