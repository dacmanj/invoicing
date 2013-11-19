jQuery ($) ->
  $(document).ready ->
  	append_template = (id,t) ->
  	 $("#template").append("<option value="+id+">"+t.name+"</option>")
  	 console.log t

  	use_template = (t) ->
  	  id = $("select#template").val()
  	  tinymce.get('message').setContent(templates[id].message)
  	  $("#subject").val(templates[id].subject)

  	if templates?
  	  append_template tmpl for tmpl in templates

  	for id,t of templates
  	  append_template id, t

  	$(".send_invoice_email").delegate "select#template", "change", use_template