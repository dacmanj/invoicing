class ChangeLineToString < ActiveRecord::Migration
  def up
  	change_column :lines, :description, :text
  end

  def down
  	change_column :lines, :description, :string
  end
end
