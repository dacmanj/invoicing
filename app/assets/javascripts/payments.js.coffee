$ -> 
	load_account = (e) ->
        a = $("#payment_invoice").val() 
        if a? 
          $.ajax({ url: "/invoices.json", data: "id=#{a}" }).done (data) ->
            $("option[value=#{data[0].account_id}]","#payment_account_id").attr("selected",true)
    $("#payment_invoice").change(load_account)

	load_invoices = (e) ->
        a = $("#payment_account_id").val() 
        if a? 
          $.ajax({ url: "/invoices.json", data: "account_id=#{a}" }).done (data) ->
            console.log data
            html = ""
            for invoice in data
              html += "<option value=#{invoice.id} data-account-id=#{invoice.account_id}>#{invoice.name} (#{invoice.balance_due} due)</option>"
            $("select#payment_invoice_id").html(html).prepend("<option value></option>")
    $("#payment_account_id").change(load_invoices);
    $(".account_buttons").insertAfter("label[for=invoice_account_id]").css("padding","0px 5px")

    $("input[name*=payment_date]").each (e) ->
        this.setCustomValidity("Please enter the date in mm/dd/yyyy format.")