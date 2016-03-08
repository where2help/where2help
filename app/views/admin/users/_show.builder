context.instance_eval do
  attributes_table do
    row :id
    row :email
    row :first_name
    row :last_name
    row :admin, as: :status_tag
    row :locale
    row :confirmed_at
    row :created_at
  end
end
