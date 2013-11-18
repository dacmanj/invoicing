# == Schema Information
#
# Table name: addresses
#
#  id            :integer          not null, primary key
#  city          :string(255)
#  state         :string(255)
#  zip           :string(255)
#  email         :string(255)
#  phone         :string(255)
#  fax           :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contact_id    :integer
#  address_lines :text
#

class Address < ActiveRecord::Base
	belongs_to :contact

  attr_accessible :address_lines, :city, :email, :fax, :phone, :state, :zip, :contact_id

  def city_state_zip
	[(self.city + "," unless self.city.blank?),self.state,self.zip].join(" ");
  end

end
