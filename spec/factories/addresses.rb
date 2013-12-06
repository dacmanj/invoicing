# == Schema Information
#
# Table name: addresses
#
#  id            :integer          not null, primary key
#  city          :string(255)
#  state         :string(255)
#  zip           :string(255)
#  email         :string(255)
#  phone         :string(255)
#  fax           :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contact_id    :integer
#  address_lines :text
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    address_line_1 "MyString"
    address_line_2 "MyString"
    address_line_3 "MyString"
    city "MyString"
    state "MyString"
    zip "MyString"
    email "MyString"
    phone "MyString"
    fax "MyString"
  end
end
