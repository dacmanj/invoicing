class AddLastEmailToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :last_email, :date
  end
end
