# == Schema Information
#
# Table name: invoices
#
#  id         :integer          not null, primary key
#  contact_id :integer
#  company_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Invoice < ActiveRecord::Base
	belongs_to :account
	belongs_to :user

	has_many :lines
	has_many :items, :through => :lines
	has_and_belongs_to_many :contacts
	accepts_nested_attributes_for :lines
	accepts_nested_attributes_for :contacts

  attr_accessible :account_id, :contact_ids, :user_id, :lines_attributes
end
