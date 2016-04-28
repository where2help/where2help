namespace :db do
  desc 'Populate DB with sample data'
  task populate: :environment do
    [User, Ngo, Event].each(&:destroy_all)
    User.create(
      email: 'admin@example.com',
      first_name: 'admin_first',
      last_name: 'admin_last',
      password: '12345678',
      confirmed_at: Time.now,
      admin: true)
    User.create(
      email: 'user@example.com',
      first_name: 'user_first',
      last_name: 'user_last',
      password: '12345678',
      confirmed_at: Time.now)
    Ngo.create(
      email: 'ngo@example.com',
      name: Faker::Company.name,
      identifier: Faker::Company.ein,
      password: '12345678',
      confirmed_at: Time.now,
      aasm_state: 'admin_confirmed',
      contact: Contact.new(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.cell_phone,
        street: Faker::Address.street_address,
        zip: Faker::Address.zip,
        city: Faker::Address.city))
    4.times do
      Ngo.create(
        email: Faker::Internet.email,
        name: Faker::Company.name,
        identifier: Faker::Company.ein,
        password: '12345678',
        confirmed_at: Time.now,
        aasm_state: 'admin_confirmed',
        contact: Contact.new(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          phone: Faker::PhoneNumber.cell_phone,
          street: Faker::Address.street_address,
          zip: Faker::Address.zip,
          city: Faker::Address.city))
    end
    Ngo.find_each do |ngo|
      10.times do
        event = Event.new(
          title: Faker::StarWars.quote,
          description: Faker::Hipster.paragraph,
          lat: Faker::Address.latitude,
          lng: Faker::Address.longitude,
          address: "#{Faker::Address.street_address}, #{Faker::Address.city}",
          ngo_id: ngo.id)
        rand(1..5).times do
          start = Time.now + rand(7).days + rand(86400).seconds
          event.shifts.new(
            starts_at: start,
            ends_at: start+2.hours,
            volunteers_needed: rand(1..20))
        end
        event.publish!
      end
    end
  end
end
