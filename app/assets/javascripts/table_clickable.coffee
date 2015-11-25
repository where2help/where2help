$ ->
  $('table.table-clickable tr').click ->
    window.location.href = $(this).data('url')
