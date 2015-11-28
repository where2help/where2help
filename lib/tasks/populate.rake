namespace :db do
  desc 'Populate DB with sample data'
  task populate: :environment do
    [User, Need].each(&:destroy_all)

    admin = User.create(
      email: 'admin@example.com',
      uid: 'admin@example.com',
      organization: 'Admin Club',
      first_name: 'real',
      last_name: 'admin',
      password: 'supersecret',
      phone: '12345678987654321',
      admin: true)

    ngo_admin = User.create(
      email: 'ngo_admin@example.com',
      uid: 'ngo_admin@example.com',
      organization: 'NGO Club',
      first_name: 'ngo',
      last_name: 'admin',
      password: 'supersecret',
      phone: '12345678987654321',
      ngo_admin: true)

    normal_user = User.create(
      email: 'normal_user@example.com',
      uid: 'normal_user@example.com',
      first_name: 'normal',
      last_name: 'user',
      password: 'supersecret',
      phone: '12345678987654321')

    cities = ['Wien', 'Salzburg', 'Graz', 'Linz']
    locations = ['Westbahnhof', 'Hauptbahnhof', 'Falcogasse 8', 'Ringstraße 10']
    50.times do
      start = Time.now + rand(7).days + rand(86400).seconds
      need = ngo_admin.needs.create(
        city: cities.sample,
        location: locations.sample,
        category: Need.categories.keys.sample,
        volunteers_needed: rand(1..50),
        start_time: start,
        end_time: start + rand(5).hours,
        description: Faker::Lorem.paragraph)
      Workers::Coords.new.perform(need.id)
    end
    puts "Data has been populated ..."
  end
end
