$ ->
	#initially selected invoice
	#initalInv = $("#payment_invoice_id").val()
	#acctInitial = $("#payment_account_id").val()
	accounts = {}
	invoices = {}
	debug = false

	load_data = () ->
		$.ajax({ url: "/invoices.json"}).done (data) ->
			invoices = data
			load_invoices

		$.ajax({ url: "/accounts.json"}).done (data) ->
			accounts = data

	load_invoices = () ->
		a = $("#payment_account_id").val()
		if console? && debug = true
			console.log "Loading Invoices for account #{a}"
		#, data: "account_id=#{a}"
		html = "<option value></option>"
		for invoice in invoices
			if +invoice.account_id != +a && a != ""
				continue
			html += "<option value=#{invoice.id} data-account-id=#{invoice.account_id}>#{invoice.name} (#{invoice.balance_due} due)</option>"
		$("select#payment_invoice_id").html(html).val(a)
		$(".account_buttons").insertAfter("label[for=invoice_account_id]").css("padding","0px 5px")

	set_account = () ->
		a = $("#payment_invoice_id option:selected").attr("data-account-id")
		if console? && debug = true
			console.log("setting account to #{a}")
		$("#payment_account_id").val(a)

  $("input[name*=payment_date]").each (v) ->
      $(this).oninvalid = (e) ->
        e.target.setCustomValidity("");
        if (!e.target.validity.valid)
          e.target.setCustomValidity("Please enter the date in mm/dd/yyyy format.")
      $(this).oninput = (e) ->
        e.target.setCustomValidity("")

	load_data()
	$("#payment_account_id").change(load_invoices)
	$("#payment_invoice_id").change(set_account)
