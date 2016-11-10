$(document).on "cocoon:after-insert", (event, insertedItem) ->
  selects = $(insertedItem).find("select")

  last_entry = $("div.inserted-fields")[$("div.inserted-fields").length - 2]
  last_selects = $(last_entry).find("select")

  for i in [0,1,2,4,5,6,7,9]
    selects[i].value = last_selects[i].value

  # set start_at hour
  selects[3].value = last_selects[8].value

  # hour overflow handling
  endhour = ((2 * parseInt(last_selects[8].value) - parseInt(last_selects[3].value)) % 24 + 24) % 24

  # day overflow handling
  selects[5].value = parseInt(selects[5].value) + 1 if (endhour < parseInt(last_selects[8].value))

  # sets ends_at hour
  selects[8].value = ("0" + endhour).slice(-2)

document.addEventListener "turbolinks:load", ->

  updateCoordinates = (suggestion) ->
    coords = suggestion.geometry.coordinates
    $('#event_lng').val coords[0]
    $('#event_lat').val coords[1]

    props = suggestion.properties
    approximate_address = (
      if props && props["Bezirk"] && props["Municipality"]
        "#{props["Bezirk"]}. Bezirk, #{props["Municipality"]}"
      else
        ""
    )
    $('#event_approximate_address').val approximate_address

  addressSearch = new Bloodhound
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value')
    queryTokenizer: Bloodhound.tokenizers.whitespace
    limit: 7
    remote:
      url: "https://data.wien.gv.at/daten/OGDAddressService.svc/GetAddressInfo?Address=%QUERY&crs=EPSG:4326"
      filter: (addresses) ->
        updateCoordinates addresses.features[0]
        addresses.features
      wildcard: '%QUERY'

  addressSearch.initialize()

  $('.typeahead').typeahead(null,
    name: 'addresse'
    source: addressSearch
    displayKey: (data) ->
      formatAddress(data.properties)
    templates:
      suggestion: (data) ->
        "<span>#{data.properties.Adresse} <small class='district'>#{data.properties.Bezirk}. Bezirk</small></span>"
  ).on 'typeahead:selected typeahead:autocompleted', (event, suggestion) ->
    updateCoordinates suggestion

  formatAddress = (properties) ->
    zip = properties.PostalCode
    zip ?= districtToZip(properties.Bezirk)
    "#{zip}, #{properties.Adresse}"

  districtToZip = (district) ->
    district = district.replace(/,.*/, "")
    if district.length > 1
      "1#{district}0"
    else
      "10#{district}0"
