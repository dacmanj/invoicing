$ ->
  $(document).ready ->
    if $('.duplicatable_nested_form').length

      nestedForm = $('.duplicatable_nested_form').last().clone()

      $('form').delegate '.destroy_duplicate_nested_form', 'click', (e) ->
        $(this).closest('.duplicatable_nested_form').slideUp().remove()

      $('.duplicate_nested_form').click (e) ->
        e.preventDefault()

        lastNestedForm = $('.duplicatable_nested_form').last()
        newNestedForm  = $(nestedForm).clone()
        formsOnPage    = $('.duplicatable_nested_form').length

        $(newNestedForm).find('label').each ->
          oldLabel = $(this).attr 'for'
          return if !oldLabel?
          newLabel = oldLabel.replace(new RegExp(/_[0-9]+_/), "_#{formsOnPage}_")
          $(this).attr 'for', newLabel

        $(newNestedForm).find('select, input, textarea').each ->
          oldId = $(this).attr 'id'
          return if !oldId?
          newId = oldId.replace(new RegExp(/_[0-9]+_/), "_#{formsOnPage}_")
          $(this).attr 'id', newId

          oldName = $(this).attr 'name'
          newName = oldName.replace(new RegExp(/\[[0-9]+\]/), "[#{formsOnPage}]")
          $(this).attr 'name', newName
          $(this).val ''

        $( newNestedForm ).insertAfter( lastNestedForm )
        $( ".duplicatable_nested_form ").last().find("textarea").tinymce("tinymce_config")
        load_items()
        add_last_position()
        assign_order()
        $('select').filter(item_filter).change(load_line_from_item)


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
            $("#invoice_primary_contact_new").attr("href","/contacts/new?id=#{a}")
      $("#invoice_account_id").change(load_contacts)

      load_items = (e) ->
        a = $("#invoice_account_id").val()
        if $("form.edit_invoice").length > 0
          i = $("form.edit_invoice").attr("id").split("_")[2] 
        else
          i = ""
        select_filter = (e) ->
          this.name.match(/invoice\[lines_attributes\]\[\d.*]\[item_id\]/)
        if a?
          $.ajax({ url: "/items.json", data: "account_id=#{a}&invoice_id=#{i}" }).done (data) ->
            selected_arr = []
            $("select").filter(select_filter).each (e) ->
              selected_arr.push $(this).val()  
            console.log selected_arr
            console.log data
            html = ""
            for item in data
              html += "<option value=#{item.id} data-account-id=#{item.account_id}>#{item.name}</option>"
            $("select").filter(select_filter).html(html).prepend("<option value></option>")
            $("select").filter(select_filter).each (i,v) ->
              $(this).val(selected_arr[i])

      $("#invoice_account_id").change(load_items)

      load_line_from_item = (e) ->
        item_id = $(this).val()
        context = $(this).closest("div.duplicatable_nested_form")
        console.log context
        console.log item_id
        if item_id? && item_id != ""
          $.ajax({url: "/items/#{item_id}.json"}).done (data) ->
            item = data
            $("input[name*=quantity]",context).val(item.quantity) if item.quantity? 
            $("input[name*=unit_price]",context).val(item.unit_price) if item.unit_price?
            description_id = $("textarea[name*=description]",context).attr("id")
            tinymce.get(description_id).setContent(item.description_with_receipt) if description_id?
            $("input[name*=notes]",context).val(item.notes) if item.notes?
            console.log item
            true

      item_filter = (e) -> 
        this.name.match(/invoice\[lines_attributes\]\[\d.*]\[item_id\]/)

      $('select').filter(item_filter).change(load_line_from_item)

      add_last_position = (e) ->
        last_position = $(".invoice_lines_position select").length
        $(".invoice_lines_position select").each (i,k) ->
          $(k).append($("<option/>").val(last_position).html(last_position))

      assign_order = (e) ->
        $(".invoice_lines_position select").each (index) ->
          val = $(this).val()
          if !!!val
            $(this).val(index+1)

      load_items()
      load_contacts()
      assign_order()


