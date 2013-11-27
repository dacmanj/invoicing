$ ->
  invoice_account_edit_click = (e) ->
    e.preventDefault()
    a = $("#invoice_account_id").val()
    if a?
      window.location.href = "/accounts/#{a}/edit"
  $("#invoice_account_edit").click(invoice_account_edit_click)