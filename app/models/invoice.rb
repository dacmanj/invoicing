# == Schema Information
#
# Table name: invoices
#
#  id                 :integer          not null, primary key
#  contact_id         :integer
#  account_id         :integer
#  user_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  date               :date
#  primary_contact_id :integer
#  ar_account         :string(255)
#  void               :boolean
#

class Invoice < ActiveRecord::Base
include ActionView::Helpers::NumberHelper
  has_paper_trail
	belongs_to :account
	belongs_to :user

  has_many :email_records
	has_many :lines, :order => "position ASC"

	has_many :items, :through => :lines
  has_many :payments

	has_and_belongs_to_many :contacts
  scope :active, where(void: false)
  scope :void, where(void: true)

  accepts_nested_attributes_for :lines, reject_if: proc { |attr| attr['description'].blank? && attr['quantity'].blank? && attr['item_id'].blank? && attr['unit_price'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :contacts, :reject_if => :all_blank

  attr_accessible :account_id, :contact_ids, :user_id, :lines_attributes, :date, :primary_contact_id, :ar_account, :void

  before_save :set_account_if_blank, :set_primary_contact_if_blank

  def self.open_invoices_as_of(balance_date)
    Invoice.active.select{|h| h.balance_due(balance_date) != 0}
  end

  def set_primary_contact_if_blank
      self.primary_contact_id = self.contacts.first.id if !self.contacts.blank? && self.primary_contact_id.blank?
      if self.contacts.blank? and self.primary_contact_id.present?
        self.contacts.push(Contact.find(primary_contact_id))
      end
  end
      
  def date=(date)
    write_attribute :date, Date.strptime(date,"%m/%d/%Y")
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

  def primary_contact
    if self.primary_contact_id.present?
      Contact.find(self.primary_contact_id)
    end
    
  end

  def other_past_due_invoices_table

    other_invoices = self.account.invoices.active.select{|h| h.balance_due != 0 && h.id != self.id}
    if other_invoices.length == 0
      return ""
    end

    html = "<h3>Other Outstanding Invoices</h3>"
    html += "<table><tbody>"
    html += "<thead><tr><th>Invoice Date</th><th>Invoice Number<th>Amount Due</th></tr></thead>"
    due = 0

    other_invoices.each do |i|
      html += "<tr><td>#{i.date.strftime("%m/%d/%Y")}</td><td>#{i.id}</td><td>#{number_to_currency(i.balance_due)}</td></tr>"
    end

    html += "</tbody></table>"

  end

  def template_keys
    template_keys = ["account_name", "contact_name", "contact_first_name", "contact_last_name",
                      "invoice_number", "invoice_total", "balance_due", "account_balance_due", "other_invoices"];
  end

  def parse_template(msg)

    msg % {  :account_name => (self.account.name unless account.blank?) || "",
             :contact_name => (self.primary_contact.name unless self.primary_contact.blank?) || "", 
             :contact_first_name => (self.primary_contact.first_name unless self.primary_contact.blank?) || "", 
             :contact_last_name => (self.primary_contact.last_name unless self.primary_contact.blank?) || "", 
             :invoice_number => self.id,
             :invoice_total => number_to_currency(self.total),
             :balance_due => number_to_currency(self.balance_due),
             :account_balance_due => self.account.balance_due,
             :other_invoices => self.other_past_due_invoices_table

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

  def balance_due(date = nil)
    if date.present?
      as_of_date = Date.strptime(date,"%m/%d/%Y")
      balance_due = 0
      if self.date <= as_of_date
        paid = 0
        self.payments.select{|p| p.payment_date <= as_of_date }.each{|p| paid += p.amount }
        balance_due = self.total - paid
      end
    else
      balance_due = self.total - self.payments_total
    end
    balance_due
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

  def changes_to_s_arr
    age = 10.seconds.ago
    @invoice_changes = self.versions.last.changeset unless self.versions.empty? || self.versions.last.created_at < age
    @lines_changes = []
    @changes = []
    self.lines.each do |l|
      @lines_changes.push [l, l.versions.last.changeset] unless l.versions.empty? || l.versions.last.created_at < age
    end
    unless @invoice_changes.nil?
      @invoice_changes.each do |k,v|
        @changes << "#{k.titlecase} changed from #{v[0]} to #{v[1]}"
      end 
    end

    #.created_at > 1.minutes.ago
    unless @lines_changes.nil?
      @lines_changes.each do |l|
        l[1].each {|k,v|
          @changes << "Line #{l[0].position}: #{k.titlecase} changed from #{v[0]} to #{v[1]}"
        }
      end 
    end
    @changes
  end

end
