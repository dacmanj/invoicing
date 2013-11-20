class InvoiceMailer < ActionMailer::Base
  default from: "invoices@pflag.org"

  def send_invoice(invoice,params)
    @invoice = invoice

    @subject = params[:subject]
    @message = params[:message]
    @email = params[:email]

  	mail(:subject => @subject, :to =>  @email) do |format|
	    format.html
	    format.pdf do
	      attachments['invoice.pdf'] = WickedPdf.new.pdf_from_string(
	        render_to_string(:pdf => "invoice",:zoom => 0.75, :template => 'invoices/show.pdf.erb')
	      )
	  	end
	end
  end
end
