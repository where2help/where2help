FactoryGirl.define do
  factory :event do
    category 1
    description "MyText"
    volunteers_needed 1
    starts_at "2016-02-25 17:01:35"
    ends_at "2016-02-25 17:01:35"
    shift_length 1
    address "MyString"
    lat 1.5
    lng 1.5
    state "MyString"
  end
end
