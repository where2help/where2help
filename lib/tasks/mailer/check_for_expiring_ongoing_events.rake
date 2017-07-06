module RakeHelpers
  module Mailer
    class CheckForExpiringOngoingEvents
      def self.notify_event_host!(ongoing_event)
        ngo = ongoing_event.ngo

        NgoMailer
          .notify_of_expiring_ongoing_event(
            ngo: ngo,
            ongoing_event: ongoing_event
          ).deliver_now

        ongoing_event.update_attribute("notified_of_expiry_at", Time.now)
      end
    end
  end
end

namespace :mailer do
  desc "Check if any NGOs should be notified about their expiring ongoing events"
  task check_for_expiring_ongoing_events: :environment do
    puts "Checking for ongoing events published 3 months ago or earlier..."

    expiring_events = OngoingEvent
      .where("published_at < ?", 3.months.ago)
      .where("renewed_at < ?", 3.months.ago)
      .where("notified_of_expiry_at < ? OR notified_of_expiry_at IS NULL", 3.months.ago)
    if expiring_events.any?
      puts "#{expiring_events.size} event#{"s" if expiring_events.size > 1} expiring:"
      expiring_events.each do |ongoing_event|
        print "- Notifying NGO hosting event #{ongoing_event.id}..."

        RakeHelpers::Mailer::CheckForExpiringOngoingEvents.notify_event_host!(ongoing_event)

        puts "OK."
      end
    else
      puts "No expiring events."
    end
  end
end
