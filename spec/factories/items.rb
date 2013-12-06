# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  description     :text
#  revenue_gl_code :string(255)
#  quantity        :decimal(, )
#  unit_price      :decimal(, )
#  item_image_url  :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notes           :string(255)
#  recurring       :boolean
#  expensify_id    :string(255)
#  invoice_id      :integer
#  account_id      :integer
#  line_id         :integer
#

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
