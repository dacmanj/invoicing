class CreateEmailRecords < ActiveRecord::Migration
  def change
    create_table :email_records do |t|
      t.integer :account_id
      t.integer :invoice_id
      t.string :email
      t.string :subject
      t.text :message

      t.timestamps
    end
  end
end
