namespace :db do
  require "net/http"
  require "uri"
  require 'json'
  require "faker"

  require Rails.root.join("db", "seeds", "address_data")

  Faker::Config.locale = :de

  desc 'Populate DB with sample data'
  task populate: :environment do
    ActiveRecord::Base.logger.level = :info

    password = "password"

    [Ngo, User, Event, OngoingEvent].each { |model| model.unscoped.map(&:really_destroy!) }
    User.create(
      email: 'admin@example.com',
      first_name: 'admin_first',
      last_name: 'admin_last',
      password: password,
      confirmed_at: Time.now,
      admin: true
    )
    User.create(
      email: 'user@example.com',
      first_name: 'user_first',
      last_name: 'user_last',
      password: password,
      confirmed_at: Time.now
    )
    25.times do |n|
      User.create(
        email: "user#{n + 1}@example.com",
        first_name: Faker::Name.first_name,
        last_name:  Faker::Name.last_name,
        password:   password,
        confirmed_at: Time.now
      )
    end

    puts "Created #{User.count} Users"

    Ngo.create(
      email: 'ngo@example.com',
      name: Faker::Company.name,
      password: password,
      confirmed_at: Time.now,
      admin_confirmed_at: Time.now,
      contact: Contact.new(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.cell_phone,
        street: Faker::Address.street_address,
        zip: Faker::Address.zip,
        city: Faker::Address.city
      )
    )
    4.times do
      Ngo.create(
        email: Faker::Internet.email,
        name: Faker::Company.name,
        password: password,
        confirmed_at: Time.now,
        admin_confirmed_at: Time.now,
        contact: Contact.new(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          phone: Faker::PhoneNumber.cell_phone,
          street: Faker::Address.secondary_address,
          zip: Faker::Address.zip,
          city: Faker::Address.city
        )
      )
    end
    2.times do
      Ngo.create(
        email: Faker::Internet.email,
        name: Faker::Company.name,
        password: password,
        confirmed_at: Time.now,
        contact: Contact.new(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          phone: Faker::PhoneNumber.cell_phone,
          street: Faker::Address.secondary_address,
          zip: Faker::Address.zip,
          city: Faker::Address.city
        )
      )
    end

    puts "Created #{Ngo.count} NGO's"

    users        = User.all
    random_users = -> {
      users.shuffle.take(rand(users.size))
    }
    address_data = AddressData.new
    approximate_address = -> (address) {
      format("%s. Bezirk, %s", address.bezirk, address.city)
    }
    real_address = -> (address) {
      zip = address.plz
      zip ||= format("10%s", address.bezirk.split(',').first.rjust(2, '0'))
      "#{zip}, #{address.address}"
    }

    Ngo.find_each do |ngo|
      10.times do
        start = Time.now + rand(7).days + rand(86400).seconds
        address = address_data.next_address
        event = Event.new(
          title: Faker::Book.title,
          description: Faker::Hipster.paragraph,
          person: Faker::Name.first_name + " " + Faker::Name.last_name + ", Tel." + Faker::PhoneNumber.cell_phone,
          lat: address.coords.lat,
          lng: address.coords.lng,
          address: real_address.call(address),
          approximate_address: approximate_address.call(address),
          ngo_id: ngo.id
        )

        rand(1..5).times do
          start += 2.hours
          event.shifts.new(
            starts_at: start,
            ends_at: start + 2.hours,
            volunteers_needed: rand(1..20)
          )
        end
        event.publish!
      end
    end

    puts "Created #{Event.count} Events"

    # Add participations to shifts
    Shift.available.each do |shift|
      random_users.call.each do |u|
        shift.users << u
      end
    end

    puts "Created #{Participation.where.not(shift_id: nil).count} Event Participations"

    # Ongoing events
    # Take a random sampling of ~ half of the Ngos

    ongoing_event_categories = OngoingEventCategory.all.to_a

    Ngo.order("RANDOM()").limit(Ngo.count / 2).all.each do |ngo|
      rand(3..8).times do
        # NOTE: Secondary address is coming from the base locale file
        address = address_data.next_address
        OngoingEvent.create(
          ongoing_event_category: ongoing_event_categories[rand(ongoing_event_categories.size)],
          title: Faker::Book.title,
          description: Faker::Hipster.paragraph,
          contact_person: Faker::Name.first_name + " " + Faker::Name.last_name + ", Tel." + Faker::PhoneNumber.cell_phone,
          lat: address.coords.lat,
          lng: address.coords.lng,
          address: real_address.call(address),
          approximate_address: approximate_address.call(address),
          volunteers_needed: rand(1..20),
          published_at: Time.now,
          ngo_id: ngo.id
        )
      end
    end

    puts "Created #{OngoingEvent.count} OngoingEvents"

    OngoingEvent.all.each do |event|
      random_users.call.each do |u|
        event.users << u
      end
    end

    puts "Created #{Participation.where.not(ongoing_event_id: nil).count} OngoingEvent Participations"
  end
end
