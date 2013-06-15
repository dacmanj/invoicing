class Address < ActiveRecord::Base
	belongs_to :contact

  attr_accessible :address_line_1, :address_line_2, :address_line_3, :city, :email, :fax, :phone, :state, :zip, :contact_id
end
