# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line do
    description "MyString"
    item_id 1
    quantity "9.99"
    unit_price "9.99"
  end
end
