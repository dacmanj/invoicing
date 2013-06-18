class AddDatabaseIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :database_id, :string
  end
end
