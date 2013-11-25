# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_record do
    account_id 1
    invoice_id 1
    email "MyString"
    subject "MyString"
    message "MyText"
  end
end
