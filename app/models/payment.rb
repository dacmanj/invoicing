class Payment < ActiveRecord::Base
  attr_accessible :amount, :company_id, :invoice_id, :payment_date, :payment_type, :reference_number
end
