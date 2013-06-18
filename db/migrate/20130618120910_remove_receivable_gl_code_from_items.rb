class RemoveReceivableGlCodeFromItems < ActiveRecord::Migration
  def up
    remove_column :items, :receivable_gl_code
  end

  def down
    add_column :items, :receivable_gl_code, :string
  end
end
