FactoryGirl.define do
  factory :shift do
    event
    starts_at { Time.now+1.day }
    ends_at { Time.now+1.day+2.hours }
    volunteers_needed 10
    volunteers_count 0

    trait :past do
      starts_at { Time.now-1.day }
      ends_at { Time.now-1.day+2.hours }
    end

    trait :full do
      volunteers_needed 10
      volunteers_count 10
    end
  end
end
