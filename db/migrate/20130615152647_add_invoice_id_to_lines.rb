class AddInvoiceIdToLines < ActiveRecord::Migration
  def change
    add_column :lines, :invoice_id, :integer
  end
end
