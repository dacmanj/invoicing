class AddBalanceDueToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :balance_due, :integer
  end
end
