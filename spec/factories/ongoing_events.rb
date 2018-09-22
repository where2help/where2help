# frozen_string_literal: true

FactoryBot.define do
  factory :ongoing_event do
    ngo
    title { "MyString" }
    description { "MyText" }
    ongoing_event_category
    address { "MyString" }
    contact_person { "MyString" }
    start_date { "2016-11-24 16:59:31" }
    end_date { "2016-11-24 16:59:31" }
    volunteers_count { 1 }
    volunteers_needed { 1 }
    lat { 1.5 }
    lng { 1.5 }

    trait :published do
      published_at { Time.now }
    end

    trait :skip_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
