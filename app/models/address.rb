# == Schema Information
#
# Table name: addresses
#
#  id             :integer          not null, primary key
#  address_line_1 :string(255)
#  address_line_2 :string(255)
#  address_line_3 :string(255)
#  city           :string(255)
#  state          :string(255)
#  zip            :string(255)
#  email          :string(255)
#  phone          :string(255)
#  fax            :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  contact_id     :integer
#

class Address < ActiveRecord::Base
	belongs_to :contact

  attr_accessible :address_line_1, :address_line_2, :address_line_3, :city, :email, :fax, :phone, :state, :zip, :contact_id
end
