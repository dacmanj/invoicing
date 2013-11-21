class AddNotesToItems < ActiveRecord::Migration
  def change
    add_column :items, :notes, :string
    add_column :items, :recurring, :boolean
  end
end
