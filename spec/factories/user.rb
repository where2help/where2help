FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password(8) }

    factory :ngo do
      ngo_admin true
      organization { Faker::Company.name }
      phone { Faker::PhoneNumber.cell_phone }
    end

    factory :admin do
      admin true
    end
  end
end
