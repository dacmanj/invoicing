class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.integer :account_id
      t.integer :address_id
      t.boolean :active
      t.string :database_id

      t.timestamps
    end
  end
end
