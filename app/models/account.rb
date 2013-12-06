# == Schema Information
#
# Table name: accounts
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  default_account_ar_account :string(255)
#  contact_id                 :integer
#  address_id                 :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  database_id                :string(255)
#  primary_contact_id         :integer
#

class Account < ActiveRecord::Base
  has_many :email_records
	has_many :contacts, dependent: :destroy
	has_many :address, :through => :contacts
	has_many :invoices
	has_many :payments
	
	attr_accessible :address_id, :primary_contact_id, :contacts, :default_account_ar_account, :name, :contacts_attributes, :address_attributes, :database_id
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :address, :reject_if => :all_blank, allow_destroy: true
  

  	def self.valid_ar_accounts
		valid_ar_accounts = ['1110','1210','1211','1212', '1221'];
  		valid_ar_accounts.map {|h| [h, h]} # name, id
  	end

  	def balance_due
  		owed = 0
  		self.invoices.each { |i| owed += i.balance_due }
  		owed
  	end

  	def unpaid_invoices
  		self.invoices.reject{|x| !x.unpaid? }
  	end

    def self.import file, override
      errors = Array.new
      CSV.foreach(file.path, headers: true) do |row|
        account = (find(row[:id]) unless row["id"].blank?) || (find_by_database_id(row["database_id"]) unless row["database_id"].blank?) || new
        #account.attributes = row.to_hash.slice(*accessible_attributes)
        account.database_id = row["database_id"]
        account.name = row["company"]

        account.default_account_ar_account = account.default_account_ar_account || "1110"
        contact = account.contacts.build
        contact.first_name = row["first_name"]
        contact.last_name = row["last_name"]
        contact.title = row["title"]
        contact.active = true
        address = Address.new
        contact.address = address
        if row["address"].blank?
          address.address_lines = [row["address_line_1"],row["address_line_2"],row["address_line_3"]].join("\n")
        else
          address.address_lines = row["address"]
        end

        address.city = row["city"]
        address.state = row["state"]
        address.zip = row["zip"]
        account.save!
        contact.save!
        address.save!
    end
    errors
    end

end
