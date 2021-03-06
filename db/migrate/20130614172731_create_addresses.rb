class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_line_1
      t.string :address_line_2
      t.string :address_line_3
      t.string :city
      t.string :state
      t.string :zip
      t.string :email
      t.string :phone
      t.string :fax

      t.timestamps
    end
  end
end
