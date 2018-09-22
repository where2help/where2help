module RakeHelpers
  module Db
    class AnonymizeDeletedUsers
      PASSWORD_ALPHABET = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten.freeze
      PASSWORD_LENGTH = 72

      def self.anonymize!(user)
        user.tap do |u|
          u.email = "user-#{u.id}@anonymized.where2help.wien"
          u.password = generate_password
          u.first_name = "(anonymized)"
          u.last_name = "(anonymized)"
          u.phone = ""
          u.anonymized_at = Time.zone.now
          u.save!
        end
      end

      def self.generate_password
        (PASSWORD_LENGTH.times.map do |_i|
          PASSWORD_ALPHABET[rand(PASSWORD_ALPHABET.size)]
        end).join
      end
    end
  end
end

namespace :db do
  desc 'Remove old User records'
  task anonymize_deleted_users: :environment do
    puts "Checking for old, soft-deleted user records..."

    threshold_date = 1.year.ago
    users = User.only_deleted
                .where('deleted_at < ?', threshold_date)
                .where('anonymized_at IS NULL', threshold_date)
                .to_a

    if users.any?
      puts "#{users.size} user#{'s' if users.size > 1} non-anonymized, soft-deleted before #{threshold_date}:"

      users.each do |user|
        print "- Anonymizing user #{user.id}... "

        RakeHelpers::Db::AnonymizeDeletedUsers.anonymize!(user)

        puts "OK."
      end
    else
      puts "No non-anonymized users marked for deletion before #{threshold_date}."
    end
  end
end
