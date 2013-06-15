# == Schema Information
#
# Table name: lines
#
#  id          :integer          not null, primary key
#  description :string(255)
#  item_id     :integer
#  quantity    :decimal(, )
#  unit_price  :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  invoice_id  :integer
#

class Line < ActiveRecord::Base
	belongs_to :invoice
	belongs_to :item

  attr_accessible :description, :item_id, :quantity, :unit_price, :invoice_id

  def item
  	@item
  end
end
