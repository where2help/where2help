FactoryGirl.define do
  factory :shift do
    starts_at { Time.now+1.day }
    ends_at { Time.now+1.day+2.hours }
    volunteers_needed 10
    volunteers_count 0

    trait :with_event do
      after :build do |shift, evaluator|
        shift.event = FactoryGirl.build(:event)
      end
    end
    
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
