class RemoveStaffContactFromInvoice < ActiveRecord::Migration
  def up
    remove_column :invoices, :staff_contact
  end

  def down
    add_column :invoices, :staff_contact, :string
  end
end
