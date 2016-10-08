FactoryGirl.define do
  factory :ngo do
    association :contact, strategy: :build
    name { Faker::Company.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :confirmed do
      confirmed_at { Time.now }
      admin_confirmed_at { Time.now }
    end
  end
end
