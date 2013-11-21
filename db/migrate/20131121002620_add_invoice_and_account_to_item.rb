class AddInvoiceAndAccountToItem < ActiveRecord::Migration
  def change
    add_column :items, :invoice_id, :integer
    add_column :items, :account_id, :integer
    add_column :items, :line_id, :integer
  end
end
