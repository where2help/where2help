context.instance_eval do
  panel 'Ongoing Event' do
    attributes_table_for ongoing_event do
      row :id
      row :ngo
      row :title
      row :contact_person
      row :address
      row :volunteers_needed
      row(:coordinates) { |event| "(#{event.lat}, #{event.lng})" }
      row(:description) { |event| format_description(event.description) }
      row :approximate_address
      row(:state){ |ngo| status_tag(Event.human_attribute_name("state-#{ngo.state}")) }
      row :created_at
      row :updated_at
      row :published_at
      row :deleted_at
      row :volunteers do
        table_for ongoing_event.users do
          column(:id) { |user| link_to(user.id, [:admin, user]) }
          column(:name) { |user| "#{user.first_name} #{user.last_name}"}
          column (:email) { |user| mail_to user.email }
          column :phone
        end
      end
    end
  end
end
