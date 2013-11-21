class AddPrimaryContactIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :primary_contact_id, :integer
  end
end
