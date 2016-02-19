FactoryGirl.define do
  factory :ngo do
    name { Faker::Company.name }
    identifier { Faker::Company.ein }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at Date.today
  end
end