class AddFileToSettings < ActiveRecord::Migration
  def self.up
    add_attachment :settings, :file
  end

  def self.down
    remove_attachment :settings, :file
  end
end
