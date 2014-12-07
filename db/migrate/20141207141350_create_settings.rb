class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key
      t.text :category
      t.text :value

      t.timestamps
    end
  end
end
