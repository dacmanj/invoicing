$ -> 
  $('.dropdown-toggle').dropdown()
  load_contacts = (e) ->
    a = $("#invoice_account_id").val() 
    if a? 
      $.ajax({ url: "/contacts.json", data: "account_id=#{a}" }).done (data) ->
  	    html = ""
  	    for contact in data
          html += "<option value=#{contact.id} data-account-id=#{contact.account_id}>#{contact.first_name}
          #{contact.last_name}</option>"
        $('select#invoice_primary_contact_id').html(html).prepend("<option value></option>")
        $('select#invoice_contact_ids').html(html);
  $("#invoice_account_id").change(load_contacts)

  load_items = (e) ->
    a = $("#invoice_account_id").val() 
    if a? 
      $.ajax({ url: "/items.json", data: "account_id=#{a}" }).done (data) ->
      	console.log data
  	    html = ""
  	    for item in data
          html += "<option value=#{item.id} data-account-id=#{item.account_id}>#{item.description}</option>"
        $("select[name^='invoice[lines_attributes]']").html(html).prepend("<option value></option>")
  $("#invoice_account_id").change(load_items)
  load_items()

  load_line_from_item = (e) ->
    item_id = $(this).val()
    context = $(this).closest("div.duplicatable_nested_form")
    console.log context
    console.log item_id
    if item_id? && item_id != ""
  	  $.ajax({url: "/items.json", data: "item_id=#{item_id}"}).done (data) ->
        item = data[0]
        $("input[name*=quantity]",context).val(item.quantity) if item.quantity? 
        $("input[name*=unit_price]",context).val(item.unit_price) if item.unit_price?
        description_id = $("textarea[name*=description]",context).attr("id")
        tinymce.get(description_id).setContent(item.description) if description_id?
        $("input[name*=notes]",context).val(item.notes) if item.notes?
        console.log item
        true

  item_filter = (e) -> 
    this.name.match(/invoice\[lines_attributes\]\[\d.*]\[item_id\]/)

  $('select').filter(item_filter).change(load_line_from_item)
