context.instance_eval do
  selectable_column
  id_column
  column :first_name
  column :last_name
  column :email
  column :phone
  column :admin
  column :locale
  column :confirmed_at
  actions
end
