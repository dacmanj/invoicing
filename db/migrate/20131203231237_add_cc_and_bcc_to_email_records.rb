class AddCcAndBccToEmailRecords < ActiveRecord::Migration
  def change
    add_column :email_records, :cc, :string
    add_column :email_records, :bcc, :string
  end
end
