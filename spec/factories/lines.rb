# == Schema Information
#
# Table name: lines
#
#  id          :integer          not null, primary key
#  description :text
#  item_id     :integer
#  quantity    :decimal(, )
#  unit_price  :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  invoice_id  :integer
#  hidden      :boolean
#  notes       :string(255)
#  position    :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line do
    description "MyString"
    item_id 1
    quantity "9.99"
    unit_price "9.99"
  end
end
