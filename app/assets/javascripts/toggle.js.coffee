$ ->
  $('#select_all_item_id').change -> 
    $('input:checkbox[name^=item_id]').prop('checked',$(this).prop("checked"));

