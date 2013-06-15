# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company do
    name "MyString"
    default_account_ar_account "MyString"
    contact_id 1
    address_id 1
  end
end
