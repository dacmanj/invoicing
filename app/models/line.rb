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
#

class Line < ActiveRecord::Base
	belongs_to :invoice
	has_one :item

  attr_accessible :description, :item_id, :quantity, :hidden, :unit_price, :invoice_id

  def item
  	@item
  end

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
