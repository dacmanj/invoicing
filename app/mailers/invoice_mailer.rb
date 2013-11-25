class InvoiceMailer < ActionMailer::Base
  default from: "PFLAG National <info@pflag.org>"

  def send_invoice(invoice,params)
    @invoice = invoice

    @subject = params[:subject]
    @message = params[:message]
    @email = "david.manuel@pflag.org"

    #params[:email]

  	mail(:subject => @subject, :to =>  @email) do |format|
	    format.html
	    format.pdf do
	      attachments['invoice.pdf'] = WickedPdf.new.pdf_from_string(
	        render_to_string(:pdf => "invoice", :template => 'invoices/show.pdf.erb', :layout => 'pdf.html', :formats => [:pdf]), :zoom => 0.75
	      )
	  	end
	end
  end
end
