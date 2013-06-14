class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :invoice_id
      t.integer :company_id
      t.date :payment_date
      t.string :payment_type
      t.string :reference_number
      t.decimal :amount

      t.timestamps
    end
  end
end
