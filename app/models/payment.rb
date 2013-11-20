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
end
