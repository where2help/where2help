namespace :db do
  require "net/http"
  require "uri"
  require 'json'

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
          street: Faker::Address.secondary_address,
          zip: Faker::Address.zip,
          city: Faker::Address.city))
    end
    Ngo.find_each do |ngo|
      10.times do
        start = Time.now + rand(7).days + rand(86400).seconds
        event = Event.new(
          title: Faker::Book.title,
          description: Faker::Hipster.paragraph,
          lat: Faker::Address.latitude,
          lng: Faker::Address.longitude,
          address: "#{Faker::Address.secondary_address}",
          ngo_id: ngo.id)
        rand(1..5).times do
            start = start + 2.hours
          event.shifts.new(
            starts_at: start,
            ends_at: start+2.hours,
            volunteers_needed: rand(1..20))
        end
        event.publish!
      end
    end

    Event.all.each do |event|
      uri = URI.parse("http://data.wien.gv.at/daten/OGDAddressService.svc/GetAddressInfo?Address=" + ERB::Util.url_encode(event.address) + "&crs=EPSG:4326")
      response = Net::HTTP.get_response(uri)
      if response.body
        coords = JSON.parse(response.body)["features"].first["geometry"]["coordinates"]
        event.update(lng: coords[0], lat: coords[1])
      end
    end
  end
end
