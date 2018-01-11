FactoryBot.define do
  factory :notification do
    notified_at "2017-04-11 15:45:04"
    type 1
    notifiable_type "MyString"
    notifiable_id 1
    user nil
  end
end
