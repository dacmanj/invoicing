class Item < ActiveRecord::Base
  attr_accessible :description, :item_image_url, :quantity, :receivable_gl_code, :revenue_gl_code, :unit_price
end
