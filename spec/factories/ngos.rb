FactoryGirl.define do
  factory :ngo do
    association :contact, strategy: :build
    name { Faker::Company.name }
    identifier { Faker::Company.ein }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
