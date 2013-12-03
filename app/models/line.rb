# == Schema Information
#
# Table name: lines
#
#  id          :integer          not null, primary key
#  description :text
#  item_id     :integer
#  quantity    :decimal(, )
#  unit_price  :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  invoice_id  :integer
#  hidden      :boolean
#  notes       :string(255)
#

class Line < ActiveRecord::Base
	belongs_to :invoice

  attr_accessible :description, :notes, :item_id, :quantity, :hidden, :unit_price, :invoice_id

  def name
    "#{self.invoice.name}-#{id}"
  end

  def total
  	t = 0
  	unless self.quantity.blank? || self.unit_price.blank?
  		t = self.quantity * self.unit_price 
  	end
  	t
  end

end
