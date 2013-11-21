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
  has_many :payments

	has_and_belongs_to_many :contacts
	accepts_nested_attributes_for :lines, reject_if: proc { |attr| attr['description'].blank? && attr['quantity'].blank? && attr['item_id'].blank? && attr['unit_price'].blank? }
	accepts_nested_attributes_for :contacts, :reject_if => :all_blank

  attr_accessible :account_id, :contact_ids, :user_id, :lines_attributes, :date, :primary_contact_id

  before_save :set_primary_contact_if_blank, :set_account_if_blank

  def set_primary_contact_if_blank
      self.primary_contact_id = self.contacts.first.id if self.primary_contact_id.blank?
  end

  def set_account_if_blank
      self.account_id = self.contacts.first.account_id if self.account_id.blank? and !self.contacts.blank?
  end

  def total
  	t = 0
  	self.lines.each do |l|
  		t += l.total
 	end
  	t
  end

  def parse_template(msg)
    msg % { :account_name => (self.account.name unless account.blank?) || "",
                :contact_name => (self.contacts.first.name unless self.contacts.first.blank?) || "", 
                :contact_first_name => (self.contacts.first.first_name unless self.contacts.first.blank?) || "", 
                :contact_last_name => (self.contacts.first.last_name unless self.contacts.first.blank?) || "", 
                :invoice_number => self.id,
                :invoice_total => self.total
                 }

  end

  def templates_json
    templates = Hash[EmailTemplate.all.to_a.each_with_object({}){|c,h| h[c.id] = { :name => c.name, :message => parse_template(c.message), :subject => parse_template(c.subject) }}].to_json
  end

  def payments_total
    paid = 0
    self.payments.each{|p| paid += p.amount }
    paid
  end

  def balance_due
    balance_due = self.total - self.payments_total
  end

  def unpaid?
    (self.total > self.payments_total)
  end

  def contact_email
  	emails = []
  	self.contacts.each do |c|
  		emails.push c.address.email unless c.address.blank?
  	end

  	emails.join(",")
  end

  def name
    account_name = (self.account.name unless self.account.blank?) || ""
    "#{account_name}-#{self.id}-#{self.date}-#{self.total}"
  end

end
