FactoryGirl.define do
  factory :shift do
    event
    starts_at "2016-02-25 17:30:55"
    ends_at "2016-02-25 17:30:55"
    volunteers_needed 1
    volunteers_count 0
  end
end
