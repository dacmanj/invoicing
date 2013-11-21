class AddPrimaryContactToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :primary_contact_id, :integer
  end
end
