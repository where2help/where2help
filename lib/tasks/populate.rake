namespace :db do
  desc 'Populate DB with sample data'
  task populate: :environment do
    [User, Need].each(&:destroy_all)

    admin = User.create(
      email: 'admin@example.com',
      first_name: 'real',
      last_name: 'admin',
      password: 'supersecret',
      phone: '12345678987654321',
      ngo_admin: true)

    ngo_admin = User.create(
      email: 'ngo_admin@example.com',
      first_name: 'ngo',
      last_name: 'admin',
      password: 'supersecret',
      phone: '12345678987654321',
      ngo_admin: true)

    normal_user = User.create(
      email: 'normal_user@example.com',
      first_name: 'normal',
      last_name: 'user',
      password: 'supersecret',
      phone: '12345678987654321')

    50.times do
      ngo_admin.needs.create(
        city: 'Wien',
        location: 'Westbahnhof',
        start_time: Time.now+2.days,
        end_time: Time.now+2.days+2.hours)
    end
  end
end
