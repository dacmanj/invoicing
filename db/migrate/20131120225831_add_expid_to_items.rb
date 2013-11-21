class AddExpidToItems < ActiveRecord::Migration
  def change
    add_column :items, :expensify_id, :string
  end
end
