FactoryBot.define do
  factory :ongoing_event_category do
    sequence :name_en do |n|
      "MyString#{n}"
    end
    sequence :name_de do |n|
      "MyString#{n}"
    end
    ordinal 100
  end
end
