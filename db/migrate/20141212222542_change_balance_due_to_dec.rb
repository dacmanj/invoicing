class ChangeBalanceDueToDec < ActiveRecord::Migration
  def up
      change_column :invoices, :balance_due, :decimal
  end

  def down
      change_column :invoices, :balance_due, :integer
  end
end
