# == Schema Information
#
# Table name: contacts
#
#  id          :integer          not null, primary key
#  first_name  :string(255)
#  last_name   :string(255)
#  account_id  :integer
#  address_id  :integer
#  active      :boolean
#  database_id :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  title       :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    first_name "MyString"
    last_name "MyString"
    company_id 1
    address_id 1
    active false
    database_id "MyString"
  end
end
