# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    invoice_id 1
    company_id 1
    payment_date "2013-06-14"
    payment_type "MyString"
    reference_number "MyString"
    amount "9.99"
  end
end
