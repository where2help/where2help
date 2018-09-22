context.instance_eval do
  panel 'NGO' do
    attributes_table_for ngo do
      row :id
      row :name
      row :email
      row :locale
      row(:state) do |ngo|
        ngo = NgoDecorator.new(ngo)
        status_tag(ngo.status)
      end
      row :created_at
      row :confirmed_at
      row :admin_confirmed_at
      row :deleted_at
    end
  end
  panel Contact.model_name.human do
    attributes_table_for ngo.contact do
      row :first_name
      row :last_name
      row :email
      row :phone
      row :street
      row :zip
      row :city
    end
  end
end
