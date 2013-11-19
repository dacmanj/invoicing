class AddNameToTemplates < ActiveRecord::Migration
  def change
    add_column :email_templates, :name, :string
  end
end
