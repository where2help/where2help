module RakeHelpers
  module OngoingEvents
    class UnpublishedUnrenewed
      def self.notify_event_host!(ongoing_event)
        ngo = ongoing_event.ngo

        NgoMailer
          .notify_of_expired_ongoing_event(
            ngo: ngo,
            ongoing_event: ongoing_event
          ).deliver_now

          ongoing_event.unpublish!
      end
    end
  end
end

namespace :ongoing_events do
  desc "Unpublish expired events and notify the ngo"
  task unpublished_unrenewed: :environment do
    puts "Checking for expired ongoing events..."

    expired_events = OngoingEvent
      .where("renewed_at < ?", Rails.configuration.require_ongoing_event_renewal_every.ago)
    if expired_events.any?
      puts "#{expired_events.size} event#{"s" if expired_events.size > 1} expired:"
      expired_events.each do |ongoing_event|
        print "- Unpublishing event and notifying NGO hosting event #{ongoing_event.id}..."

        RakeHelpers::OngoingEvents::UnpublishedUnrenewed.notify_event_host!(ongoing_event)

        puts "OK."
      end
    else
      puts "No expired events."
    end
  end
end
