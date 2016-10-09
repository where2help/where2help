context.instance_eval do
  panel 'Event' do
    attributes_table_for event do
      row :id
      row :ngo
      row :title
      row :address
      row(:coordinates) { |event| "(#{event.lat}, #{event.lng})" }
      row(:state){ |event| status_tag(event.aasm.human_state) }
      row :created_at
      row :updated_at
    end
  end
  panel Shift.model_name.human(count: 2) do
    if event.deleted?
      @shifts = event.shifts.only_deleted
    else
      @shifts = event.shifts
    end
    @shifts.each do |shift|
      attributes_table_for shift do
        row :id
        row :starts_at
        row :ends_at
        row :deleted_at
        row :volunteers_needed
        row :volunteers_count
        row :volunteers do
          table_for shift.users do
            column(:id) { |user| link_to(user.id, [:admin, user]) }
            column(:name) { |user| "#{user.first_name} #{user.last_name}"}
            column :email
            column :phone
          end
        end
      end
    end
  end
end
