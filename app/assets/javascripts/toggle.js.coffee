$ ->
  $('#select_all_item_id').change -> 
    $('input:checkbox[name^=item_id]').prop('checked',$(this).prop("checked"));
  $('#select_all_invoice_id').change -> 
    $('input:checkbox[name^=invoice_id]').prop('checked',$(this).prop("checked"));