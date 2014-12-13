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
  resourcify
  include Authority::Abilities
  belongs_to :invoice
  belongs_to :account
	
  attr_accessible :amount, :account_id, :invoice_id, :invoice, :account, :payment_date, :payment_type, :reference_number
<<<<<<< HEAD
  after_save :update_balance
  after_destroy :update_balance
=======
  after_save :update_invoice
>>>>>>> 070625f2a508d608f45522ad23cb6f4932fff92c
    
  def self.valid_payment_types
    ["Check","Credit Card","Cash","Adjustment"]    
  end
      
  def payment_date=(date)
    write_attribute :payment_date, Date.strptime(date,"%m/%d/%Y")
  end
    
  def self.import file
  	errors = Array.new
  	CSV.foreach(file.path, headers: true) do |row|
      payment = new
  		i = Invoice.find(row["invoice_id"])
      payment.invoice = i
  		payment.account = i.account
      payment.payment_date = Date.strptime row["payment_date"], '%m/%d/%Y' unless row["payment_date"].blank?
      payment.payment_type = row["payment_type"] unless row["payment_type"].blank?
      payment.reference_number = row["reference_number"] unless row["reference_number"].blank?
      payment.amount = row["amount"]
	    payment.save!
	end
  errors
  end
  private
    def update_invoice
        self.invoice.update_total_and_balance
    end
end
