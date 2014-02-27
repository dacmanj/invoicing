class InvoiceMailer < ActionMailer::Base
  default from: "PFLAG National <invoices@pflag.org>"

  def new_invoice_email(invoice, current_user)
    @invoice = invoice
    @username = current_user.name
    email = User.notify_all.collect(&:email)
    email.push(@invoice.user.email) unless @invoice.user.blank? || @invoice.user.email.blank?
    @email = email.join(", ") 
    
    if invoice.account.blank?
      @account_name = ""
    else
      @account_name = invoice.account.name 
    end
    @subject = "New Invoice Created for #{@account_name} by #{@username}"

    mail(:subject => @subject, :to =>  @email, :cc => @email_cc, :bcc => @email_bcc)

  end

  def new_payment_email(payment, current_user)
    @payment = payment
    @invoice = payment.invoice
    @account = payment.account
    @username = current_user.name
    if @account.blank?
      @account_name = ""
    else
      @account_name = @account.name 
    end
    email = User.notify_all.collect(&:email)
    email.push(@invoice.user.email) unless @invoice.user.blank? || @invoice.user.email.blank?
    @email = email.join(", ") 
    @subject = "New Payment Posted for #{@account_name} by #{@username}"
    mail(:subject => @subject, :to =>  @email, :cc => @email_cc, :bcc => @email_bcc)

  end

  def payment_edited_email(payment,current_user)
    @payment = payment
    @invoice = payment.invoice
    @account = payment.account
    @username = current_user.name
    if @account.blank?
      @account_name = ""
    else
      @account_name = @account.name 
    end
    email = User.notify_all.collect(&:email)
    email.push(@invoice.user.email) unless @invoice.user.blank? || @invoice.user.email.blank?
    @email = email.join(", ") 
    mail(:subject => @subject, :to =>  @email, :cc => @email_cc, :bcc => @email_bcc)
  end

  def invoice_edited_email(invoice,current_user)
    @invoice = invoice
    @username = current_user.name
    if @invoice.account.blank?
      @account_name = ""
    else
      @account_name = invoice.account.name 
    end
    @subject = "Invoice #{@invoice.id} Updated by #{@username}"
    email = User.notify_all.collect(&:email)
    email.push(@invoice.user.email) unless @invoice.user.blank? || @invoice.user.email.blank?
    @email = email.join(", ") 
    mail(:subject => @subject, :to =>  @email, :cc => @email_cc, :bcc => @email_bcc)

  end

  def send_invoice(invoice,params)
    @invoice = invoice
    @subject = params[:subject]
    @message = params[:message]
    @email = params[:email]
    @email_cc = params[:email_cc]
    @email_bcc = params[:email_bcc]


    #params[:email]

  	mail(:subject => @subject, :to =>  @email, :cc => @email_cc, :bcc => @email_bcc) do |format|
	    format.html
	    format.pdf do
	      attachments['invoice.pdf'] = WickedPdf.new.pdf_from_string(render_to_string(:pdf => "invoice", :template => 'invoices/show.pdf.erb', :layout => 'pdf.html', :formats => [:pdf]), :zoom => 0.75)
	  	end
    end

    unless params[:test_email] == "yes"
      email_record = EmailRecord.new do |e|
        e.account = @invoice.account
        e.invoice = @invoice
        e.subject = @subject
        e.message = @message
        e.email = @email
        e.cc = @email_cc
        e.bcc = @email_bcc
      end
      email_record.save!

    end

  end

end
