class AddTotalToLines < ActiveRecord::Migration
  def change
    add_column :lines, :total, :decimal
  end
end
