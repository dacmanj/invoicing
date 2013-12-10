class InvoicesController < ApplicationController
  before_filter :authenticate
  # GET /invoices
  # GET /invoices.json
  def index

    @invoices = Invoice.includes(:email_records)

    if (params[:ar_account].present?)
      @invoices = @invoices.find_all_by_ar_account(params[:ar_account])
    end

    if (params[:balance_due_as_of_date].present?)
      @invoices = @invoices.select{|h| h.balance_due(params[:balance_due_as_of_date]) != 0}
    end

    if (params[:id].present?)
      @invoices = @invoices.find_all_by_id(params[:id])
    end

    if (params[:account_id].present?)
      @invoices = @invoices.find_all_by_account_id(params[:account_id])
    end

    if (params[:outstanding_balance] == "yes")
      @invoices = @invoices.select{|h| h.balance_due != 0}
    end

    if (params[:name])
      @invoices = @invoices.select{|h| h.name.downcase.match(params[:name].downcase)}
    end


    case params[:sort]
    when "date"
      @invoices = @invoices.sort{|a,b| b.date <=> a.date}
    when "ar"
      @invoices = @invoices.sort {|a,b| a.ar_account <=> b.ar_account}
    when "last_email"
#      @invoices = Invoice.includes(:email_records).order('email_records.created_at DESC NULLS LAST').uniq
      @invoices = @invoices.sort{|a,b| 

        (b.email_records.last.blank? ? DateTime.new : b.email_records.last.created_at) <=> (a.email_records.last.blank? ? DateTime.new : a.email_records.last.created_at)

      }
    when "total"
      @invoices = @invoices.sort {|a,b| b.total <=> a.total}
    when "balance_due"
      @invoices = @invoices.sort {|a,b| b.balance_due <=> a.balance_due}
    when "id"
      @invoices = @invoices.sort {|a,b| b.id <=> a.id}
    else
      @invoices = @invoices.sort {|a,b| b.date <=> a.date}
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoices.to_json(:methods => [:name, :balance_due]) }
      format.csv { render csv: @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html { render layout: "invoice"}
      format.json { render json: @invoice }
      format.pdf do
                            # always change zoom/parameters here in invoice_mailer.rb to ensure consistent invoices
        render :pdf => "invoices", :layout => "pdf.html", :zoom => 0.75, :show_as_html => params[:debug].present?
        #, :show_as_html => true
      end
    end
  end

  def email
    @invoice = Invoice.find(params[:id])
  end

  def send_email
    @invoice = Invoice.find(params[:id])
    if @invoice.nil?
      redirect_to invoices_url, notice: "Invoice not found." 
    else
      InvoiceMailer.send_invoice(@invoice,params).deliver
      redirect_to invoices_url, notice: "Invoice #{params[:id]} was successfully sent to #{params[:email]}." 
    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice = Invoice.new
    @invoice.user = current_user

    if params[:account_id].present?
      @invoice.account = Account.find(params[:account_id])
      @invoice.ar_account = @invoice.account.default_account_ar_account
      @invoice.primary_contact_id = @invoice.account.contacts.first.id unless @invoice.account.blank? or @invoice.account.contacts.blank?
      if @invoice.account.contacts && @invoice.account.contacts.count == 1
        @invoice.contacts.push @invoice.account.contacts.first
      end
    end

    if params[:item_id]
      @items = Item.find_all_by_id(params[:item_id])
      @items.each do |i|
        line = Line.new
        if i.item_image_url
          img_link = "(<a href='#{i.item_image_url}'>Receipt</a>)'"
        end
        line.description = "#{i.description} #{img_link}"
        line.item_id = i.id
        line.notes = i.notes
        line.quantity = i.quantity
        line.unit_price = i.unit_price
        @invoice.lines.push line
      end
    end

    @invoice.account = @invoice.account || (@items.first.account unless @items.blank?)

    @invoice.lines.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])

  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoices_url, notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def build
    @invoice = Invoice.find(params[:id])
    
  end

  # PUT /invoices/1
  # PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to invoices_url, notice: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_multiple
    @invoices = Invoice.find_all_by_id(params[:invoice_id])
    errors = Array.new
    email_template_id = params[:email_template_id]

    errors.push("No invoices selected") unless @invoices.present?
    errors.push("No template selected") unless params[:email_template_id].present?

    if errors.present?
      redirect_to invoices_url, notice: errors.join(", ")
      return
    end

    template = EmailTemplate.find(email_template_id)
    success_count = 0

    @invoices.each do |i| 
      if params[:delete] == "1"
        i.destroy
        next
      end
        email = { :message => i.parse_template(template.message),
                  :subject => i.parse_template(template.subject) }

        email[:email_cc] = "#{i.user.email unless i.user.blank? || params[:test_email]}"

        email[:email] = "#{current_user.name} <#{current_user.email}>"

        if params[:test_email] != "yes" && (i.contacts.select{|h| h.address.present? && h.address.email.present? }.count == 0 )
          errors.push("No valid email addresses on invoice #{i.id}")
        else
          email[:test_email] = params[:test_email]
          if params[:test_email] != "yes"
            email[:email] = i.contacts.map{|h| "#{h.name} <#{h.address.email}>" unless (h.address.blank? || h.address.email.blank?) }
            email[:email].push("#{i.user.name} <#{i.user.email}>") unless i.user.blank?
            email[:email].join(",")
          end
          InvoiceMailer.send_invoice(i,email).deliver
          success_count += 1
        end

    end
    errors.push "#{success_count} invoice#{'s' unless success_count == 1} successfully emailed." unless success_count == 0
    message =  errors.join(", ")
    redirect_to invoices_url, notice: message
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end
end
