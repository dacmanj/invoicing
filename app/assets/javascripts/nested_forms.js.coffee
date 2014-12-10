$ ->
  $(document).ready ->
    debug = console && false
    if $('.duplicatable_nested_form').length

      nestedForm = $('div#template.duplicatable_nested_form').clone().removeAttr("id")


      $('form').delegate '.destroy_duplicate_nested_form', 'click', (e) ->
        $(this).closest('.duplicatable_nested_form').slideUp().remove()

      $('form').on 'click','.duplicate_nested_form', (e) ->
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

      $("form").on "click","#toggle_line_items_collapsed", (e) ->
        expand = $("#toggle_line_items_collapsed #expand").is(":visible")
        if expand == true
          $("div.panel-body").slideDown().removeClass("hidden-panel")
          $(".title-text .unit-price").hide()
          $("#toggle_line_items_collapsed #expand").hide()
          $("#toggle_line_items_collapsed #collapse").show()
        else #collapse
          $("div.panel-body").slideUp().addClass("hidden-panel")
          $("div.panel").each (e,v) ->
            unit_price = $(v).find("input[name*=unit_price]").val() || 0
            $(v).find(".unit-price").html("("+$.toCurrency(unit_price)+")").show()
          $("#toggle_line_items_collapsed #collapse").hide()
          $("#toggle_line_items_collapsed #expand").show()


            
      collapse_line_items = () ->
        $("#line_items div.panel").each (e,v) ->
          collapse_line_item $(this)
        
      $("form").on 'click', '#line_items h3.panel-title .title-text', (e) ->
        panel_body = $(this).closest("div.panel").find(".panel-body")
        unit_price = panel_body.find("input[name*=unit_price]").val() || 0
        if panel_body.hasClass("hidden-panel")
          panel_body.slideDown()
          panel_body.removeClass("hidden-panel")
          $(this).find(".unit-price").hide()
        else
          panel_body.slideUp()
          panel_body.addClass("hidden-panel")
          $(this).find(".unit-price").html("("+$.toCurrency(unit_price)+")").show()

      modal_submit = (e) ->
        e.preventDefault()
        form = $(".modal-content form")
        data = form.serialize()
        url = $(".modal-content form").attr("action") + ".json"
        $.post(url, data, modal_success).fail(modal_error)

      modal_success = (data) ->
        console.log data if debug
        form = $(".modal-content form #modal_form")
        if form
          action = form.attr("data-action")
          model = form.attr("data-model")
        if model == 'account' && data.id?
          id = data.id
          $("select#invoice_account_id").prepend("<option value='#{data.id}'>#{data.name}</option>")
          $("#invoice_account_id").val(id)
          load_accounts()
        else
          load_accounts()
        BootstrapDialog.closeAll()

      modal_error = (request) ->
        if console? && debug
          console.log "ajax request"
          console.log request
        flash_div = $(".modal-content div#modal_error")
        msg = decodeURIComponent(request.getResponseHeader("X-Message")) || ""
        msg_type = request.getResponseHeader("X-Message-Type") || ""
        if request.status == 500
          msg = "500 Server Error"
          msg_type = "error"
        if msg?.length and msg_type?.length
          console.log "Flash Message: #{msg}" if console? && debug

          alert_type = 'alert-success'
          alert_type = 'alert-danger' if msg_type.match("error") != null
          console.log "Flash Message Type: #{alert_type}" if console? && debug
          flash_div.html("
                      <div class='alert " + alert_type + "'>
                        <button type='button' class='close' data-dismiss='alert'>&times;</button>
                        #{msg}
                      </div>").show()
        #delete the flash message (if it was there before) when an ajax request returns no flash message
        else 
          flash_div.html("").hide()
        hideflash = -> flash_div.fadeOut()
        setTimeout hideflash, 5000
        true


      $("body").on("submit", ".modal-content form", modal_submit)
      $("#line_items").sortable({
              placeholder: "sortable-placeholder panel panel-default",
              opacity: 0.75,
              sortable: "div.panel"
            })
         
      $("#line_items").bind "sortactivate", (e) ->
        console.log "activated" if console
#        $(".duplicatable_nested_form .panel-body").not(".ui-sortable-helper").not(".sortable-placeholder").slideUp()
        $(this).find('textarea.tinymce').each (v) ->
          tinyMCE.execCommand('mceRemoveEditor',true, $(this).attr('id'));
          $(this).hide()

      $("#line_items").bind "sortdeactivate", (e) ->
        console.log "deactivate" if console
#        $(".duplicatable_nested_form .panel-body").slideDown()
        $(this).find('textarea.tinymce').each (v) ->
          $(this).show()
          tinyMCE.execCommand( 'mceAddEditor', true, $(this).attr('id') )

      $("#line_items").bind "sortupdate", (e) ->
        assign_order()

      submit_ajax = (e) ->
        e.preventDefault()
        tinyMCE.triggerSave();
        form = $(this)
        url = form.attr('action') + ".json"
        data = form.serialize()
        $.post(url, data, submit_success).fail(submit_error)
      
      submit_success = (e,req) ->
        $("#invoice-preview iframe").attr("src",$("#invoice-preview iframe").attr("src"))
        $("dd.balance_due").html($.toCurrency(e.balance_due)) unless isNaN(e.balance_due)
        update_lines(e.lines) if e.lines != undefined
      
      update_lines = (e) ->
        $("#line_items .duplicatable_nested_form").not("#template").each () ->
            position = $("[name*=position]",this).val()
            replace_num = $("[name*=position]").attr("name").split("[")[2].split("]")[0]
            $("input",this).each () -> 
                name = $(this).attr("name")
                console.log(name)
                new_name = name.replace(replace_num,position)
                console.log(new_name)
                console.log($(this).attr("name",new_name))

        for line in e
          position = line.position
          for k,v of line
            id = "#invoice_lines_attributes_" + position + "_" + k
            result = $(id).val(v).length
            if (k == "id" && result == 0)
              html_id="invoice_lines_attributes_#{position}_id"
              name = "invoice[lines_attributes][#{position}][id]"
              console.log $("<input type='hidden' id='#{html_id}' name='#{name}' value='#{v}'/>").insertAfter($("#invoice_lines_attributes_#{position}_notes").closest(".form-group"))
            
    
      submit_error = (e) ->
        console.log("error") if console
            
      $(".edit_invoice, .new_invoice").submit(submit_ajax)

      modal_links_target_blank = (e) ->
        links = $(".modal-content a[data-method!=delete]").attr("target","_BLANK")

      open_link_as_modal = (e) ->
        e.preventDefault()
        url = $(this).attr("href")
        title = $(this).attr("title") || ""
        if (url == "")
          return
        if url.indexOf("?") > -1
          url = url + "&modal=true"
        else
          url = url + "?modal=true"
        BootstrapDialog.show({
            size: BootstrapDialog.SIZE_LARGE,
            title: title, #todo get name
            message: $('<div></div>').load(url),
            onshown: modal_links_target_blank
        })

      $(window).bind 'beforeunload', (e) ->
        if $(".modal-dialog").length >= 1
          msg = 'Leaving this page will not save your current edits.'
        else
          msg = undefined
        return msg


      $("a.modal_opener").on("click",open_link_as_modal)

      load_accounts = (e) ->
        e.preventDefault() if e

        selected = $("#invoice_account_id").val()
        $.ajax({ url: "/accounts.json" }).done (data) ->
          html = ""
          for account in data
            html += "<option value=#{account.id}>#{account.name}</option>"
          $("select#invoice_account_id").html(html).prepend("<option value></option>")
          $("select#invoice_account_id").val(selected)
          load_contacts()
          load_items()


      $("a#refresh_accounts").click(load_accounts)

      set_account_edit_link = (e) ->
        selected = $("#invoice_account_id").val()
        if (selected == "")
          url = ""
        else
          url = "/accounts/" + selected + "/edit"
        $("#edit_account_button").attr("href",url)

      $("#invoice_account_id").on("change",set_account_edit_link)



      load_contacts = (e) ->
        e.preventDefault() if e
        a = $("#invoice_account_id").val() 
        pc = $("#invoice_primary_contact_id").val()
        c = $("#invoice_contact_ids").val()
        if a? 
          $.ajax({ url: "/contacts.json", data: "account_id=#{a}" }).done (data) ->
            html = ""
            for contact in data
              html += "<option value=#{contact.id} data-account-id=#{contact.account_id}>#{contact.first_name}
              #{contact.last_name}</option>"
            $('select#invoice_primary_contact_id').html(html).prepend("<option value></option>")
            $('select#invoice_contact_ids').html(html);
            $("#invoice_primary_contact_new").attr("href","/contacts/new?id=#{a}")
            $("#invoice_primary_contact_id").val(pc)
            $("#invoice_contact_ids").val(c)

      $("#invoice_account_id").change(load_contacts)
      $("a#refresh_contacts").click(load_contacts)


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
            console.log selected_arr if debug
            console.log data if debug
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
        console.log context if debug
        console.log item_id if debug
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
        $(".invoice_lines_position input").each (index) ->
          $(this).val(index)

      set_account_edit_link()
      load_items()
      load_contacts()
      assign_order()


