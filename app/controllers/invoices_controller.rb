class InvoicesController < ApplicationController
  before_filter :authenticate
  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.order("id DESC")
    if (params[:outstanding_balance] == "yes")
      @invoices = @invoices.select{|h| h.balance_due != 0}
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoices }
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
    InvoiceMailer.send_invoice(@invoice,params).deliver
    redirect_to invoices_url, notice: "Invoice #{params[:id]} was successfully sent to #{params[:email]}." 
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice = Invoice.new
    @invoice.user = current_user

    if !params[:account_id].blank?
      @invoice.account = Account.find(params[:account_id])
      @invoice.primary_contact_id = @invoice.account.contacts.first.id unless @invoice.account.blank? or @invoice.account.contacts.blank?
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
    @invoice.lines.build

  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to items_url, notice: 'Invoice was successfully created.' }
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
    template = EmailTemplate.find(email_template_id)

    @invoices.each do |i| 
      if params[:delete] == "1"
        i.destroy
        next
      end
        email = { :message => i.parse_template(template.message),
                  :subject => i.parse_template(template.subject) }

        email[:email_cc] = "#{i.user.email unless i.user.blank? || params[:test_email]}"

        email[:email] = "#{current_user.name} <#{current_user.email}>"
        if params[:test_email] != "yes" && (i.contacts.count == 0 || i.contacts.map{|h| h.address.email unless h.address.blank?})
          errors.push("No valid email addresses on invoice #{i.id}")
        else
          email[:email] = i.contacts.map{|h| "#{h.address.name} <#{h.address.email}>" unless h.address.blank? || h.address.email.blank? }.push("#{i.user.email unless i.user.blank?}").join(",") unless params[:test_email] == "yes"
          InvoiceMailer.send_invoice(i,email).deliver
        end

    end

    message =  (errors.length > 0) ? errors.join(", ") : "Invoices successfully emailed."
    if errors.length > 0
      redirect_to invoices_url
    else
      redirect_to invoices_url, notice: message
    end
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
