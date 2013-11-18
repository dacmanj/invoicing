# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  description     :string(255)
#  revenue_gl_code :string(255)
#  quantity        :decimal(, )
#  unit_price      :decimal(, )
#  item_image_url  :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Item < ActiveRecord::Base
  has_many :lines
  attr_accessible :description, :item_image_url, :quantity, :receivable_gl_code, :revenue_gl_code, :unit_price

  def total
  	quantity * unit_price
  end
end
