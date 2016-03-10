FactoryGirl.define do
  factory :ngo do
    association :contact, strategy: :build
    name { Faker::Company.name }
    identifier { Faker::Company.ein }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    factory :confirmed_ngo do
      confirmed_at Time.now
      aasm_state 'admin_confirmed'
    end
  end
end
