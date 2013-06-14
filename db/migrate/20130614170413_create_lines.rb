class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :description
      t.integer :item_id
      t.decimal :quantity
      t.decimal :unit_price

      t.timestamps
    end
  end
end
