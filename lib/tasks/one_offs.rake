namespace :one_offs do
  desc "Move events that should be ongoing to ongoing"
  task :ongoing_migrate => :environment do
    event_ids = [10, 11, 12, 14, 17, 18, 19, 20, 22, 26, 27]
    Event.transaction do
      # for each event
      Event.where(id: event_ids).each do |event|
        # find the volunteers assigned to the shifts
        users = event.shifts.flat_map { |shift|
          shift.users
        }.uniq
        # get the event details
        # create a new ongoing event with the same details
        ongoing = OngoingEvent.create(
          title:               event.title,
          description:         event.description,
          address:             event.address,
          lat:                 event.lat,
          lng:                 event.lng,
          ngo_id:              event.ngo_id,
          approximate_address: event.approximate_address,
          contact_person:      event.person,
          volunteers_needed:   event.volunteers_needed,
          published_at:        event.published_at,
          deleted_at:          event.deleted_at,
          created_at:          event.created_at
        )
        # add volunteers to ongoing event
        ongoing.users << users
        # remove original event
        event.destroy
      end
    end
  end
end
