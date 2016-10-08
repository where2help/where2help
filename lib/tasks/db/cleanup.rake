namespace :db do
  desc 'Remove old User records'
  task cleanup: :environment do
    User.only_deleted
      .where('deleted_at < ?', 1.year.ago)
      .map(&:really_destroy!)
  end
end
