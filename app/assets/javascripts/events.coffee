# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#starts-at-datetime-picker').datetimepicker
    locale: 'de'
  $('#ends-at-datetime-picker').datetimepicker
    locale: 'de'

$(document).on "fields_added.nested_form_fields", (event, param) ->
  $(dateField).datetimepicker(
    locale: 'de'
  ) for dateField in $(event.target).find('.date')
