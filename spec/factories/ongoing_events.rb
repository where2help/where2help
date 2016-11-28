FactoryGirl.define do
  factory :ongoing_event do
    ngo nil
    title "MyString"
    description "MyText"
    address "MyString"
    contact_person "MyString"
    start_date "2016-11-24 16:59:31"
    end_date "2016-11-24 16:59:31"
    volunteers_count 1
    volunteers_needed 1
    latitude 1.5
    lng 1.5
  end
end
