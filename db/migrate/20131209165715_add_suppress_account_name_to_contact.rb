class AddSuppressAccountNameToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :suppress_account_name, :boolean
  end
end
