FactoryGirl.define do
  factory :bot_message do
    provider "MyString"
    from_bot false
    payload ""
    account_id 1
  end
end
