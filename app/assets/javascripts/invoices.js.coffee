$ ->
  invoice_account_edit_click = (e) ->
    e.preventDefault()
    a = $("#invoice_account_id").val()
    if a != ""
      window.location.href = "/accounts/#{a}/edit"
  $("#invoice_account_edit").click(invoice_account_edit_click)
  invoice_primary_contact_edit_click = (e) ->
    e.preventDefault()
    c = $("#invoice_primary_contact_id").val()
    if c?
      window.location.href = "/contacts/#{c}/edit"
  $("#invoice_primary_contact_edit").click(invoice_primary_contact_edit_click)
