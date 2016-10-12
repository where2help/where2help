context.instance_eval do
  panel 'Event' do
    attributes_table_for event do
      row :id
      row :ngo
      row :title
      row :person
      row :address
      row(:coordinates) { |event| "(#{event.lat}, #{event.lng})" }
      row(:state){ |ngo| status_tag(Event.human_attribute_name("state-#{ngo.state}")) }
      row :created_at
      row :updated_at
      row :published_at
      row :deleted_at
    end
  end
  panel Shift.model_name.human(count: 2) do
    if event.deleted?
      @shifts = event.shifts.only_deleted
    else
      @shifts = event.shifts
    end
    @shifts.each do |shift|
      if shift.deleted?
        @users = @users = User.where(
          id: shift.participations.only_deleted.pluck(:user_id)
        )
      else
        @users = shift.users
      end
      attributes_table_for shift do
        row :id
        row :starts_at
        row :ends_at
        row :deleted_at
        row :volunteers_needed
        row :volunteers_count
        row :volunteers do
          table_for @users do
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
