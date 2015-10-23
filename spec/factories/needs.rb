FactoryGirl.define do
  factory :need do
    city { Faker::Address.city  }
    location { Faker::Address.street_name }
  end
end
