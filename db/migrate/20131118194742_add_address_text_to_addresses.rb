class AddAddressTextToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :address_lines, :text
  end
end
