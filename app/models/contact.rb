# == Schema Information
#
# Table name: contacts
#
#  id          :integer          not null, primary key
#  first_name  :string(255)
#  last_name   :string(255)
#  company_id  :integer
#  address_id  :integer
#  active      :boolean
#  database_id :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Contact < ActiveRecord::Base
	belongs_to :account
	has_many :addresses
	accepts_nested_attributes_for :addresses
	has_and_belongs_to_many :invoices

	attr_accessible :active, :account_id, :database_id, :first_name, :last_name, :addresses_attributes

	def name
		first_name + " " + last_name
	end

end
