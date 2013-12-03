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

class Contact < ActiveRecord::Base
	belongs_to :account
	has_one :address, dependent: :destroy
	accepts_nested_attributes_for :address
	has_and_belongs_to_many :invoices


	attr_accessible :active, :account_id, :database_id, :first_name, :last_name, :title, :address, :address_attributes

	scope :active, where(:active => true) 

	def name
		"#{first_name} #{last_name}"
	end

end
