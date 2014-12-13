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
#  position    :integer
#

class Line < ActiveRecord::Base
	belongs_to :invoice
  has_paper_trail

  attr_accessible :description, :notes, :item_id, :quantity, :hidden, :unit_price, :invoice_id, :position
  before_validation :assign_item, :update_total
  after_save :update_invoice
  after_destroy :update_invoice
    
  def name
    if self.invoice.present?
      "#{self.invoice.name}-#{id}"
    else
      "#{id}"
    end
  end

  private
    
 def assign_item
    if self.item_id.present?
      item = Item.find(self.item_id)
      if item.recurring != true
        item.invoice_id = self.invoice_id
        item.account_id = self.invoice.account.id unless self.invoice.blank? || self.invoice.account.blank?
        item.save!
      end
    end
    true
  end


  def update_invoice
    if self.invoice.present?
        invoice.update_total_and_balance
    end
    true
  end
  def update_total
  	t = 0
  	unless self.unit_price.blank?
  		t = (self.quantity || 1) * self.unit_price 
  	end
  	self.total = t
    true
  end

end
