$.extend $.expr[":"], { "containsNC": (elem, i, match, array) ->
  return (elem.textContent || elem.innerText || "").toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0 
  }


$ ->
  $("#account-search").keyup (e) ->
    rows = $("#accounts-table").find("tr").hide();
    data = this.value.split(" ");
    if (data.length == 1 && data[0] == "")
      rows.show()
    $.each data, (i, v) ->
      rows.filter(":containsNC('" + v + "')").show();

$ ->
  $("#invoice-search").keyup (e) ->
    rows = $("#invoices-table").find("tr").hide();
    data = this.value.split(" ");
    if (data.length == 1 && data[0] == "")
      rows.show()
    $.each data, (i, v) ->
      rows.filter(":containsNC('" + v + "')").show();

