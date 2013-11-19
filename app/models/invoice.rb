# == Schema Information
#
# Table name: invoices
#
#  id         :integer          not null, primary key
#  contact_id :integer
#  account_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  date       :date
#

class Invoice < ActiveRecord::Base
	belongs_to :account
	belongs_to :user

	has_many :lines
	has_many :items, :through => :lines
	has_and_belongs_to_many :contacts
	accepts_nested_attributes_for :lines, reject_if: proc { |attr| attr['description'].blank? && attr['quantity'].blank? && attr['item_id'].blank? && attr['unit_price'].blank? }
	accepts_nested_attributes_for :contacts, :reject_if => :all_blank

  attr_accessible :account_id, :contact_ids, :user_id, :lines_attributes, :date

  def total
  	t = 0
  	self.lines.each do |l|
  		t += l.total
 	end
  	t
  end

  def contact_email
  	emails = []
  	self.contacts.each do |c|
  		emails.push c.address.email unless c.address.blank?
  	end

  	emails.join(",")
  end

end
