FactoryGirl.define do
  factory :event do
    title { Faker::StarWars.planet }
    description { Faker::Hipster.paragraph(2) }
    address "MyString"
    lat 1.5
    lng 1.5

    after :build do |event, evaluator|
      event.shifts << FactoryGirl.build(:shift, event: nil)
    end

    trait :published do
      state 'published'
    end
  end
end
