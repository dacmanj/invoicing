class AddVoidToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :void, :boolean, :default => false
  end
end
