$ -> 
  $('.dropdown-toggle').dropdown()
  load_contacts = (e) ->
    a = $("#invoice_account_id").val() 
    $.ajax({ url: "http://127.0.0.1:3000/contacts.json", data: "account_id=#{a}" }).done (data) ->
  	  console.log data
  	  html = ""
  	  for contact in data
        html += "<option value=#{contact.id} data-account-id=#{contact.account_id}>#{contact.first_name}
        #{contact.last_name}</option>"
      $('select#invoice_primary_contact_id').html(html);
      $('select#invoice_primary_contact_id').prepend("<option value></option>");
      $('select#invoice_contact_ids').html(html);
  $("#invoice_account_id").change(load_contacts)
