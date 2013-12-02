class InvoiceMailer < ActionMailer::Base
  default from: "PFLAG National <invoices@pflag.org>"



  def send_invoice(invoice,params)
    @invoice = invoice
    @subject = params[:subject]
    @message = params[:message]
    @email = params[:email]
    email_cc = params[:email_cc]


    #params[:email]

  	mail(:subject => @subject, :to =>  @email, :cc => email_cc) do |format|
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
      end
      email_record.save!

    end

  end
end
