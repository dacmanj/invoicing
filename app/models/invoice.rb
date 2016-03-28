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
#  void               :boolean          default(FALSE)
#  balance_due        :decimal(, )
#  last_email         :date
#  total              :decimal(, )
#

class Invoice < ActiveRecord::Base
    include Filterable
    resourcify
    include Authority::Abilities
    include ActionView::Helpers::NumberHelper
    has_paper_trail

    #relationships
    belongs_to :account
    belongs_to :user
    has_and_belongs_to_many :contacts
    has_many :email_records
    has_many :lines, :order => "position ASC", :dependent => :delete_all
    has_many :items, :through => :lines
    has_many :payments, :dependent => :delete_all

    #filters
    scope :active, where(void: false)
    scope :void, where(void: true)
    scope :account_id, -> (account_id) { where account_id: account_id }
    scope :ar_account, -> (ar_account) { where ar_account: ar_account }
    scope :account_name, -> (account_name) { joins(:account).where('lower(accounts.name) like ?','%' + account_name.downcase + '%')}
    scope :balance_due, where("balance_due > 0")
    scope :paid, where("balance_due <= 0")

    #sorting scopes
    scope :by_ar_account, -> (dir = "ASC") { order("ar_account #{dir}") }
    scope :by_total, -> (dir = "DESC") { order("total #{dir}") }
    scope :by_balance_due, -> (dir = "DESC") { order("balance_due #{dir}") }
    scope :by_id, -> (dir = "DESC") { order("id #{dir}") }
    scope :by_date, -> (dir = "DESC") { order("date #{dir}") }
    scope :by_last_email, -> (dir = "ASC") { order("last_email #{dir}") }

    #valid attributes
    accepts_nested_attributes_for :lines, reject_if: proc { |attr| attr['description'].blank? && attr['quantity'].blank? && attr['item_id'].blank? && attr['unit_price'].blank? }, allow_destroy: true
    accepts_nested_attributes_for :contacts, :reject_if => :all_blank

    attr_accessible :account_id, :contact_ids, :user_id, :lines_attributes, :date, :primary_contact_id, :ar_account, :void, :balance_due,:last_email, :total

    #callbacks
    before_save :set_account_if_blank, :set_primary_contact_if_blank

    def self.open_invoices_as_of(balance_date)
        Invoice.active.select{|h| h.balance_as_of(balance_date) != 0}
    end

    def date=(date)
        write_attribute :date, Date.strptime(date,"%m/%d/%Y")
    end

    def primary_contact
        if self.primary_contact_id.present?
          Contact.find(self.primary_contact_id)
        end
    end

    def all_past_due_invoices_table

        outstanding_invoices = self.account.invoices.active.select{|h| h.balance_due != 0 }
        if outstanding_invoices.length == 0
          return ""
        end

        html = "<h3>Outstanding Invoices</h3>"
        html += "<table border=1><tbody>"
        html += "<thead><tr><th>Invoice Date</th><th>Invoice Number<th>Amount Due</th></tr></thead>"
        due = 0

        outstanding_invoices.each do |i|
          html += "<tr><td>#{i.date.strftime("%m/%d/%Y")}</td><td>#{i.id}</td><td>#{number_to_currency(i.balance_due)}</td></tr>"
        end

        html += "</tbody></table>"

    end

    def all_past_due_pledges_table

        outstanding_invoices = self.account.invoices.active.select{|h| h.balance_due != 0 }
        if outstanding_invoices.length == 0
          return ""
        end

        html = "<h3>Outstanding Pledges</h3>"
        html += "<table border=1><tbody>"
        html += "<thead><tr><th>Pledge Date</th><th>Invoice Number<th>Amount Due</th></tr></thead>"
        due = 0

        outstanding_invoices.each do |i|
          html += "<tr><td>#{i.date.strftime("%m/%d/%Y")}</td><td>#{i.id}</td><td>#{number_to_currency(i.balance_due)}</td></tr>"
        end

        html += "</tbody></table>"

    end
    def other_past_due_invoices_table

        other_invoices = self.account.invoices.active.select{|h| h.balance_due != 0 && h.id != self.id}
        if other_invoices.length == 0
          return ""
        end

        html = "<h3>Other Outstanding Invoices</h3>"
        html += "<table border=1><tbody>"
        html += "<thead><tr><th>Invoice Date</th><th>Invoice Number<th>Amount Due</th></tr></thead>"
        due = 0

        other_invoices.each do |i|
          html += "<tr><td>#{i.date.strftime("%m/%d/%Y")}</td><td>#{i.id}</td><td>#{number_to_currency(i.balance_due)}</td></tr>"
        end

        html += "</tbody></table>"

    end

    def template_keys
        template_keys = ["account_name", "contact_name", "contact_first_name", "contact_last_name",
                      "invoice_number", "invoice_total", "balance_due", "account_balance_due", "other_invoices","outstanding_invoices","outstanding_pledges"];
    end

    def parse_template(msg)

        msg % {  :account_name => (self.account.name unless account.blank?) || "",
                 :contact_name => (self.primary_contact.name unless self.primary_contact.blank?) || "",
                 :contact_first_name => (self.primary_contact.first_name unless self.primary_contact.blank?) || "",
                 :contact_last_name => (self.primary_contact.last_name unless self.primary_contact.blank?) || "",
                 :invoice_number => self.id,
                 :invoice_total => number_to_currency(self.total),
                 :balance_due => number_to_currency(self.balance_due),
                 :account_balance_due => number_to_currency(self.account.balance_due),
                 :other_invoices => self.other_past_due_invoices_table,
                 :outstanding_invoices => self.all_past_due_invoices_table,
                 :outstanding_pledges => self.all_past_due_pledges_table

        }

    end

    def templates_json
        templates = Hash[EmailTemplate.all.to_a.each_with_object({}){|c,h| h[c.id] = { :name => c.name, :message => parse_template(c.message), :subject => parse_template(c.subject) }}].to_json
    end

    def update_total_and_balance
        self.total = self.lines.sum(:total)
        self.balance_due = (self.total - self.payments.sum(:amount)) || 0
        self.save
        true
    end

    def update_last_email
        update_attributes(:last_email => email_records.last.created_at.to_date) unless email_records.blank?
    end

    def self.balance_due_as_of(date = nil)
      invoices = all.select {|s| s.balance_due_as_of(date.to_s) > 0}
    end

    def balance_due_as_of(date = nil)
        if date.present?
          as_of_date = Date.strptime(date,"%m/%d/%Y")
          balance = 0
          if self.date <= as_of_date
            paid = 0
            self.payments.where("payment_date <= ?",as_of_date ).each{|p| paid += p.amount }
            balance = self.total - paid
          end
        else
          balance = self.balance_due
        end
        balance
    end

    def unpaid?
        (self.balance_due > 0)
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

    def primary_contact_email
        (self.primary_contact.address.email unless (self.primary_contact.blank? || self.primary_contact.address.blank?)) || ""
    end
    def primary_contact_phone
        (self.primary_contact.address.phone unless (self.primary_contact.blank? || self.primary_contact.address.blank?)) || ""
    end

    def lines_summary
        summary = ""
        self.lines.each do |l|
            summary << Nokogiri::HTML(l.description).text + "\n"
        end
        summary
    end

private
    def set_primary_contact_if_blank
      self.primary_contact_id = self.contacts.first.id if !self.contacts.blank? && self.primary_contact_id.blank?
      if self.contacts.blank? and self.primary_contact_id.present?
        self.contacts.push(Contact.find(primary_contact_id))
      end
    end

    def set_account_if_blank
      self.account_id = self.contacts.first.account_id if self.account_id.blank? and !self.contacts.blank?
    end

    def update_total_and_balance_before_save
        self.total = self.lines.sum(:total)
        self.balance_due = self.total - self.payments.sum(:amount)
    end

end
