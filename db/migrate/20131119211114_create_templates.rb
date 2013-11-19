class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.string :subject
      t.text :message

      t.timestamps
    end
  end
end
