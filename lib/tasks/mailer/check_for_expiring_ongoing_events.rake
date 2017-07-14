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
      .where("renewed_at < ?", Rails.configuration.require_ongoing_event_renewal_every.ago)
      .where("notified_of_expiry_at < ? OR notified_of_expiry_at IS NULL", Rails.configuration.remind_of_ongoing_events_before_expiry.ago)
      .where("renewed_at > notified_of_expiry_at")
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
