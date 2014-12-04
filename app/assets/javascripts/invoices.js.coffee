$ ->  
  invoice_primary_contact_edit_change = (e) ->
    e.preventDefault()
    c = $(this).val()
    if c?
      $("#invoice_primary_contact_edit").attr("href","/contacts/#{c}/edit")
  $("#invoice_primary_contact_id").change(invoice_primary_contact_edit_change)
