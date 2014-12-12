# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  email                 :string(255)
#  provider              :string(255)
#  uid                   :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  notify_on_all_actions :boolean          default(FALSE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    provider "twitter"
    uid "12345"
    name "Bob"
  end
end
