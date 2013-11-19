class RemoveAddresslinesFromAddresses < ActiveRecord::Migration
  def up
    remove_column :addresses, :address_line_1
    remove_column :addresses, :address_line_2
    remove_column :addresses, :address_line_3
  end

  def down
    add_column :addresses, :address_line_3, :string
    add_column :addresses, :address_line_2, :string
    add_column :addresses, :address_line_1, :string
  end
end
