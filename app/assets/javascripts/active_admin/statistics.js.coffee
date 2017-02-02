$ ->
  date_form = $("#statistics-date-form")
  if date_form.length > 0
    date_form.find(".datepicker").on "change", ->
      $(".statistics-result-row").css("opacity", 0.5)
    date_form.on("ajax:success", (e, data, status, xhr) ->
      for name, value of data.update_fields
        $("#statistics-field-#{name}").text(value)
        $(".statistics-result-row").show().css("opacity", 1.0)
    ).on "ajax:error", (e, xhr, status, error) ->
      alert("Fehler beim Laden der Statistik: #{error}")