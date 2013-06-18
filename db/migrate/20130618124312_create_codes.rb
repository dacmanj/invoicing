class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.string :category
      t.string :code
      t.string :value

      t.timestamps
    end
  end
end
