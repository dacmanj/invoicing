# == Schema Information
#
# Table name: payments
#
#  id               :integer          not null, primary key
#  invoice_id       :integer
#  account_id       :integer
#  payment_date     :date
#  payment_type     :string(255)
#  reference_number :string(255)
#  amount           :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

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
