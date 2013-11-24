# == Schema Information
#
# Table name: payments
#
#  id               :integer          not null, primary key
#  invoice_id       :integer
#  account_id       :integer
#  payment_date     :date
#  payment_type     :string(255)
#  reference_number :string(255)
#  amount           :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Payment < ActiveRecord::Base
	belongs_to :invoice
	belongs_to :account
	
  attr_accessible :amount, :account_id, :invoice_id, :payment_date, :payment_type, :reference_number

  def self.import file, override
  	errors = Array.new
  	CSV.foreach(file.path, headers: true) do |row|
  		i = Invoice.find(row["invoice_id"])
  		a = i.account
  		payment = new
	    payment.account = a
	    payment.invoice = Inv
	    item.attributes = row.to_hash.slice(*accessible_attributes)
	    item.revenue_gl_code = item.revenue_gl_code || "4442"
	    item.save!
	end
  errors
  end
end
