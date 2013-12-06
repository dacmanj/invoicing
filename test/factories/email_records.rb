# == Schema Information
#
# Table name: email_records
#
#  id         :integer          not null, primary key
#  account_id :integer
#  invoice_id :integer
#  email      :string(255)
#  subject    :string(255)
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cc         :string(255)
#  bcc        :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_record do
    account_id 1
    invoice_id 1
    email "MyString"
    subject "MyString"
    message "MyText"
  end
end
