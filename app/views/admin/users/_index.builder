context.instance_eval do
  selectable_column
  id_column
  column :email
  column :first_name
  column :last_name
  column :phone
  column :admin
  column :locale
  column :confirmed_at
  column :created_at
  actions
end
