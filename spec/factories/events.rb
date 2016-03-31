FactoryGirl.define do
  factory :event do
    title { Faker::StarWars.planet }
    description { Faker::Hipster.paragraph(2) }
    shift_length 1
    address "MyString"
    lat 1.5
    lng 1.5
    state "MyString"
  end
end
