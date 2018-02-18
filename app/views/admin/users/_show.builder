context.instance_eval do
  attributes_table do
    row :id
    if user.locked?
      row(:locked) { |b| status_tag "LOCKED", class: "red" }
    end
    row :email
    row :first_name
    row :last_name
    row :phone
    row :admin, as: :status_tag
    row :locale
    row :confirmed_at
    row :created_at
  end
end
