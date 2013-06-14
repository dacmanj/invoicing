class ContactsInvoices < ActiveRecord::Migration
  def up
  	create_table 'contacts_invoices', :id => false do |t|
	    t.column :contacts_id, :integer
	    t.column :invoices_id, :integer
	end
  end

  def down
  	delete_table 'contacts_invoices'
  end
end
