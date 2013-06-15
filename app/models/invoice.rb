class Invoice < ActiveRecord::Base
	belongs_to :company
	belongs_to :user
	
	has_many :lines
	has_and_belongs_to_many :contacts
	accepts_nested_attributes_for :lines
	accepts_nested_attributes_for :contacts

  attr_accessible :company_id, :contact_ids, :user_id
end
