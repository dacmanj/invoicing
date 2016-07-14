$ ->
	i = $("#payment_invoice_id").val()
	filter_invoices = (e) ->
		a = $("#payment_account_id").val()
		b = $("#payment_invoice_id option").filter () ->
			a == $(this).attr("data-account-id")
#		console.log "Activating #{a}"
		$("#payment_invoice_id option:enabled").attr('disabled',true)
		b.removeAttr('disabled')
		$(this).attr("data-account-id") == undefined
		$("#payment_invoice_id option:enabled").eq(0).prop('selected',true)
		$("#payment_invoice_id option").eq(0).removeAttr('disabled')


	load_account = (e) ->
        a = $("#payment_invoice").val()
        if a?
          $.ajax({ url: "/invoices.json", data: "id=#{a}" }).done (data) ->
            $("option[value=#{data[0].account_id}]","#payment_account_id").attr("selected",true)
    $("#payment_invoice").change(load_account)

	load_invoices = (e) ->
    a = $("#payment_account_id").val()
    $.ajax({ url: "/invoices.json", data: "account_id=#{a}" }).done (data) ->
      html = ""
      for invoice in data
        html += "<option value=#{invoice.id} data-account-id=#{invoice.account_id}>#{invoice.name} (#{invoice.balance_due} due)</option>"
      $("select#payment_invoice_id").html(html).prepend("<option value></option>").val("");

    $("#payment_account_id").change(filter_invoices)
    $(".account_buttons").insertAfter("label[for=invoice_account_id]").css("padding","0px 5px")
    $("#payment_invoice_id").change(set_account)

  set_account = (e) ->
      $("#payment_account_id").val($("select#payment_invoice_id option:selected").attr("data-account-id"))
			filter_invoices()

  $("input[name*=payment_date]").each (v) ->
      $(this).oninvalid = (e) ->
        e.target.setCustomValidity("");
        if (!e.target.validity.valid)
          e.target.setCustomValidity("Please enter the date in mm/dd/yyyy format.")
      $(this).oninput = (e) ->
        e.target.setCustomValidity("")

#	load_invoices()
	$("#payment_invoice_id").val(i)
