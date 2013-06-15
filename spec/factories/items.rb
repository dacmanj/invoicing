# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    description "MyString"
    revenue_gl_code "MyString"
    receivable_gl_code "MyString"
    quantity "9.99"
    unit_price "9.99"
    item_image_url "MyString"
  end
end
