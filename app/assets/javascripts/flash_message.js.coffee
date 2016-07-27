#ajax call to show flash messages when they are transmitted in the header
#this code assumes the following
# 1) you're using twitter-bootstrap (although it will work if you don't)
# 2) you've got a div with the id flash_message somewhere in your html code

debug = false

$ -> 
  console.log "ajaxFlashLoading..." if console? && debug
  flash_msg_event = (event, request) ->
    msg = decodeURIComponent(request.getResponseHeader("X-Message")) || ""
    msg_type = request.getResponseHeader("X-Message-Type") || ""
    if console? && debug
      console.log "ajax request"
      console.log request
      console.log request.getAllResponseHeaders()
      console.log "message: #{msg}"
      console.log "message_type: #{msg_type}"


    if request.status == 500
      msg = "500 Server Error"
      msg_type = "error"
    if msg?.present?
      console.log "Flash Message: #{msg}" if console? && debug

      alert_type = 'alert-success'
      alert_type = 'alert-danger' if msg_type.match("error") != null
      console.log "Flash Message Type: #{alert_type}" if console? && debug
      $("#flash-message").html("
                  <div class='alert " + alert_type + "'>
                    <button type='button' class='close' data-dismiss='alert'>&times;</button>
                    #{msg}
                  </div>").show()
      $("body").scrollTop(0)
      hideflash = -> $("#flash-message").fadeOut()
      setTimeout hideflash, 5000

    true

  file_upload_event = (e,r) ->
    result = confirm("Are you sure?")
    e.preventDefault()
    return result

  $(document).on "ajaxComplete", flash_msg_event
  
  