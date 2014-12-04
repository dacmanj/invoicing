$ ->  
  invoice_primary_contact_edit_change = (e) ->
    e.preventDefault()
    c = $("#invoice_primary_contact_id").val()
    if c?
      $(this).attr("href","/contacts/#{c}/edit")
  $("#invoice_primary_contact_edit").change(invoice_primary_contact_edit_change)
