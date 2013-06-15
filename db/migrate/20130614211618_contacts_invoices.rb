class ContactsInvoices < ActiveRecord::Migration
  def up
  	create_table 'contacts_invoices', :id => false do |t|
	    t.column :contact_id, :integer
	    t.column :invoice_id, :integer
	end
  end

  def down
  	delete_table 'contacts_invoices'
  end
end
