# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  description     :string(255)
#  revenue_gl_code :string(255)
#  quantity        :decimal(, )
#  unit_price      :decimal(, )
#  item_image_url  :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notes           :string(255)
#  recurring       :boolean
#  expensify_id    :string(255)
#  invoice_id      :integer
#  account_id      :integer
#  line_id         :integer
#

class Item < ActiveRecord::Base
  belongs_to :account
  belongs_to :line

  scope :not_assigned_to_account, where("account_id is NULL")
  scope :not_assigned_to_line, where("account_id is NOT NULL AND line_id is NULL")
  scope :active, where(:active => true) 


  attr_accessible :description, :item_image_url, :quantity, :receivable_gl_code, :revenue_gl_code, :unit_price, :notes, :recurring, :expensify_id

  def total
  	quantity * unit_price
  end

  def self.import file, override
  	errors = Array.new
  	CSV.foreach(file.path, headers: true) do |row|
  		if !(row['billable'] == "true")
  			next
  		end
  		e_id = find_by_expensify_id(row["expensify_id"])
  		if e_id and !override
  			errors.push ("Ignoring potential duplicate #{row['expensify_id']}")
  			next
  		end
	    item = e_id || new
	    item.attributes = row.to_hash.slice(*accessible_attributes)
	    item.revenue_gl_code = item.revenue_gl_code || "4442"
	    item.save!
	end
  errors
  end
end
