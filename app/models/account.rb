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
	has_many :invoices
	
  	attr_accessible :address_id, :contact_ids, :default_account_ar_account, :name
end
