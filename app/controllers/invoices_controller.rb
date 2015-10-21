class InvoicesController < ApplicationController
  before_filter :authenticate, :except => [:index]
  before_filter :check_key, :only => [:index]
    
  authorize_actions_for Invoice
  # GET /invoices
  # GET /invoices.json
  def index
    @filter_params = params.slice(:id,:account_id,:ar_account,:void,:account_name)
    @invoices = Invoice.active unless params[:void].present?
    @invoices = @invoices.filter(@filter_params)
    @invoices = @invoices.account_name(params[:name]) if (params[:name].present?)

    if params[:sort].in? ["date","ar_account","last_email","total","balance_due","id"]
        @invoices = @invoices.send("by_"+params[:sort],params[:dir])
    else
        @invoices = @invoices.by_date
    end
      
    if (params[:balance_due_as_of_date].present? and params[:balance_due_as_of_date] != Date.today and params[:balance_due_as_of_date] != "today")
      @invoices = @invoices.balance_due_as_of(params[:balance_due_as_of_date])
      @outstanding_balance = true
      @balance_due_as_of_date = params[:balance_due_as_of_date]
    elsif (( params[:commit].blank? && params[:all].blank? ) || params[:outstanding_balance] == "yes")
      @balance_due_as_of_date = Date.today
      @outstanding_balance = true
      @invoices = @invoices.balance_due
    end


    error = Payment.select{|p| p.payment_date.blank?}.map(&:id).join(", ")
    if error.present?
      error = "Payments missing payment_date: " + error
    end

    respond_to do |format|
      flash.alert = error if error.present?
      format.html # index.html.erb
      format.json { render json: @invoices.to_json(:methods => [:name]) }
      format.csv { render csv: @invoices }
    end
  end
  def indexold
    @invoices = Invoice.includes(:email_records)
    @invoices = @invoices.ar_account(params[:ar_account]) if (params[:ar_account].present?)

    if (params[:id].present?)
      @invoices = Invoices.find(params[:id])
    end

    if (params[:account_id].present?)
      @invoices = @invoices.account_id(params[:account_id])
    end

    if (params[:name])
      @invoices = @invoices.select{|h| h.name.downcase.match(params[:name].downcase)}
    end

    case params[:sort]
    when "date"
      @invoices = @invoices.sort{|a,b| b.date <=> a.date}
    when "ar_account"
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

    error = Payment.select{|p| p.payment_date.blank?}.map(&:id).join(", ")
    if error.present?
      error = "Payments missing payment_date: " + error
    end

    if (params[:balance_due_as_of_date].present?)
      @invoices = @invoices.find_all{|h| h.balance_due_as_of(params[:balance_due_as_of_date]) != 0}
      @outstanding_balance = true
    elsif (( params[:commit].blank? && params[:all].blank? ) || params[:outstanding_balance] == "yes")
      @outstanding_balance = true
      @invoices = @invoices.find_all{|h| h.balance_due != 0}
    end
      
    respond_to do |format|
      flash.alert = error if error.present?
      format.html # index.html.erb
      format.json { render json: @invoices.to_json(:methods => [:name]) }
      format.csv { render csv: @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @invoice = Invoice.find(params[:id])
    
    disposition = (params[:download] == "true") ? "attachment" : ""

    respond_to do |format|
      format.html { render html: @invoice }
      format.json { render json: @invoice.to_json(:methods => :name) }
      format.pdf do
        # always change zoom/parameters here in invoice_mailer.rb to ensure consistent invoices
        render :pdf => "PFLAG Invoice #{@invoice.id}", :layout => "pdf.html", :zoom => 0.75, :page_size => "letter", :show_as_html => params[:debug].present?, :locals => {:wicked_pdf => true}, :disposition => disposition
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
      count = 0
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
        line.position = count+=1
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
        @invoice.reload
        InvoiceMailer.new_invoice_email(@invoice, current_user).deliver
        flash[:notice] = 'Invoice was successfully created'
        format.html { redirect_to edit_invoice_url(@invoice.id), notice: flash[:notice] }
        format.json { render json: @invoice.to_json(:include => :lines), status: :created, location: @invoice }
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
        @invoice.reload
        flash[:notice] = 'Invoice was successfully updated.'
        format.html { redirect_to invoice_url(@invoice.id) }
        format.json { render json: @invoice.to_json(:include => :lines)}
        InvoiceMailer.invoice_edited_email(@invoice,current_user).deliver
      else
        flash[:errors] = @invoice.errors
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
        email[:email_bcc] = "dmanuel@pflag.org, jodyhuckaby@pflag.org, asauerwalt@pflag.org"

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
#    @invoice.destroy
    @invoice.void = true
    @invoice.save

    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end
  private
  def check_key
      user = User.find_all_by_provider_and_uid("Token",params[:key]).first
      if !params[:key].present? || user.nil?
        authenticate
      else #key present and user not nil
        session[:user_id] = user.id
      end
  end
end
