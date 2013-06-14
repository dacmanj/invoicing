class AddDatabaseIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :database_id, :string
  end
end
