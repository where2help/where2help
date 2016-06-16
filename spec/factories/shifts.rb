FactoryGirl.define do
  factory :shift do
    starts_at { Time.now+1.day }
    ends_at { Time.now+1.day+2.hours }
    volunteers_needed 10
    volunteers_count 0
    association :event, factory: [:event, :with_shift]

    trait :past do
      starts_at { Time.now-1.day }
      ends_at { Time.now-1.day+2.hours }
    end

    trait :full do
      volunteers_needed 10
      volunteers_count 10
    end

    trait :skip_validate do
      to_create {|instance| instance.save(validate: false) }
    end
  end
end
