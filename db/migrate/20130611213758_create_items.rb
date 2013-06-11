class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :description
      t.string :revenue_gl_code
      t.string :receivable_gl_code
      t.decimal :quantity
      t.decimal :unit_price
      t.string :item_image_url

      t.timestamps
    end
  end
end
