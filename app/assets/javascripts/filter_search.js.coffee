$.extend $.expr[":"], { "containsNC": (elem, i, match, array) ->
  return (elem.textContent || elem.innerText || "").toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0 
  }


$ ->
  $("#account-search").keyup (e) ->
    rows = $("tr.account-row").addClass("filtered")
    data = this.value.split(" ")
    if (data.length == 1 && data[0] == "")
      rows.removeClass("filtered")
    $.each data, (i, v) ->
      rows.filter(":containsNC('" + v + "')").removeClass("filtered")

  $("#invoice-search").keyup (e) ->
    rows = $("tr.invoice-row").addClass("filtered")
    data = this.value.split(" ")
    if (data.length == 1 && data[0] == "")
      rows.removeClass("filtered")
    $.each data, (i, v) ->
      rows.filter(":containsNC('" + v + "')").removeClass("filtered")
    a = 0
    $("tr.invoice-row").not(".filtered").each (v) -> 
      a = a + $(this).attr("data-amount")*1
    