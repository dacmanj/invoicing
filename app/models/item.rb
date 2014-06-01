# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  description     :text
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
  has_many :lines
  has_paper_trail

  scope :not_assigned_to_account, where("account_id is NULL")
  scope :not_assigned_to_line, where("line_id is NULL")
  scope :active, where(:active => true) 
  scope :recurring, where(:recurring => true)

  attr_accessible :description, :item_image_url, :quantity, :receivable_gl_code, :revenue_gl_code, :unit_price, :notes, :recurring, :expensify_id, :account_id, :line_id

  def total
  	quantity * unit_price
  end

  def unassigned?
    self.lines.blank? || self.recurring?
  end

  def description_text
    Nokogiri::HTML(self.description).text
  end

  def description_with_receipt
    if self.item_image_url
        img_link = "(<a href='#{self.item_image_url}'>Receipt</a>)" unless self.item_image_url.blank?
    end
    "#{self.description} #{img_link}"
  end

  def name
    text = self.description_text
    "#{self.notes + ": " unless self.notes.blank?}#{text}"
  end

  def assign_to_invoice(id)
    if (id?)
      invoice = Invoice.find(id)
      line = Line.new
      line.invoice_id = invoice.id
      if self.item_image_url
        img_link = "(<a href='#{self.item_image_url}'>Receipt</a>)"
      end
      line.description = "#{self.description} #{img_link}"
      line.item_id = self.id
      line.quantity = self.quantity
      line.unit_price = self.unit_price
      line.save!

      if invoice.account.blank?
        invoice.account_id = self.account_id
        invoice.save!
      end

      unless self.recurring?
        self.account_id = invoice.account.id
        self.line_id = line.id 
        self.invoice_id = invoice.id 
      end
      self.save!
    end
  end

  def self.search(params, operator = "AND")
    s = Array.new
    p = Array.new
    params.each_pair do |k,v|
      v = "TRUE" if (v == "yes")
      v = "FALSE" if (v == "no")
      if k.in? Item.accessible_attributes and v != ''
        if k.in? ["notes", "description"]
          s.push("items.#{k} ILIKE ?")
          p.push("\%#{v}\%")

        else
          if k != 'lines.id'
            s.push("items.#{k} = ?")
          else
            s.push("#{k} = ?")
          end
          p.push(v)

        end
      end
    end
    s = s.join(" #{operator} ")
    if params[:assigned].present?
      if params[:commit] == "Filter"
        s += " AND " unless s.blank?
      else
        s += " OR " unless s.blank?
      end
      s += "lines.id is NOT NULL"
    end
    if params[:recurring].blank? and params[:assigned].blank?
      if params[:commit] == "Filter" 
        s += " AND " unless s.blank?
      else
        s += " OR " unless s.blank?
      end
      s += "recurring = 'yes'" 
    end

    Item.includes(:lines).where(s,*p).order("items.recurring DESC, items.account_id, items.invoice_id")

  end

  def self.import file, override
  	errors = Array.new
    imported = 0
  	CSV.foreach(file.path, headers: true) do |row|
      logger.info row['billable']
  		if !(row['billable'] == "true")
  			next
  		end
  		item = (find_by_expensify_id(row["expensify_id"]) unless row["expensify_id"].blank? )
      a = Account.find_by_database_id(row["database_id"]) unless row["database_id"].blank?
  		if item and !override
  			errors.push ("Ignoring potential duplicate #{row['expensify_id']}")
  			next
  		end
      item = item || new
      item.account = a
	    item.attributes = row.to_hash.slice(*accessible_attributes)
	    item.revenue_gl_code = item.revenue_gl_code || "4442"
	    if (item.save!)
        imported += 1
      end
	end
  errors.push("Imported #{imported} item#{"s" unless imported == 1}.")
  end
end
