class AddArAccountToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :ar_account, :string
  end
end
