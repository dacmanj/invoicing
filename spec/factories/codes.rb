# == Schema Information
#
# Table name: codes
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  code       :string(255)
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :code do
    category "MyString"
    code "MyString"
    value "MyString"
  end
end
