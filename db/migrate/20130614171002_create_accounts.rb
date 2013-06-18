class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :default_account_ar_account
      t.integer :contact_id
      t.integer :address_id

      t.timestamps
    end
  end
end
