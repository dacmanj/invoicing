class AddNotifyOnAllActionsToUser < ActiveRecord::Migration
  def change
    add_column :users, :notify_on_all_actions, :boolean, :default => false
  end
end
