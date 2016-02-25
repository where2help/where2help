FactoryGirl.define do
  factory :contact do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
    street { Faker::Address.street_address }
    zip { Faker::Address.zip }
    city { Faker::Address.city }
  end
end
