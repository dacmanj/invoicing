# == Schema Information
#
# Table name: accounts
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  default_account_ar_account :string(255)
#  contact_id                 :integer
#  address_id                 :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  database_id                :string(255)
#

class Account < ActiveRecord::Base
	has_many :contacts
	has_many :addresses, :through => :contacts
	has_many :invoices
	accepts_nested_attributes_for :contacts, :addresses
  	attr_accessible :address_id, :contact, :contacts, :default_account_ar_account, :name, :contact_attributes


  	def self.valid_ar_accounts
		valid_ar_accounts = ['1110'];
  		valid_ar_accounts.map {|h| [h, h]} # name, id
  	end

end
