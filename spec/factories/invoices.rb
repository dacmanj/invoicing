# == Schema Information
#
# Table name: invoices
#
#  id                 :integer          not null, primary key
#  contact_id         :integer
#  account_id         :integer
#  user_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  date               :date
#  primary_contact_id :integer
#  ar_account         :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    contact_id 1
    company_id 1
    user_id 1
    staff_contact "MyString"
  end
end
