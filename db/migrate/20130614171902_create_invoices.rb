class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :contact_id
      t.integer :account_id
      t.integer :user_id
      t.string :staff_contact

      t.timestamps
    end
  end
end
