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
#

class Line < ActiveRecord::Base
  attr_accessible :description, :item_id, :quantity, :unit_price
end
