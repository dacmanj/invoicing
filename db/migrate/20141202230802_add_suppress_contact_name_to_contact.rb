class AddSuppressContactNameToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :suppress_contact_name, :boolean
  end
end
