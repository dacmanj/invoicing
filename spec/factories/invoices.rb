# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    contact_id 1
    company_id 1
    user_id 1
    staff_contact "MyString"
  end
end
