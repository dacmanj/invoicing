# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    first_name "MyString"
    last_name "MyString"
    company_id 1
    address_id 1
    active false
    database_id "MyString"
  end
end
