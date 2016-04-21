$(document).on "cocoon:after-insert", (event, insertedItem) ->
  selects = $(insertedItem).find("select")
  
  last_entry = $("div.inserted-fields")[$("div.inserted-fields").length - 2]
  last_selects = $(last_entry).find("select")

  for i in [0,1,2,4,5,6,7,9]
    selects[i].value = last_selects[i].value

  # set start_at hour
  selects[3].value = last_selects[8].value

  # hour overflow handling
  endhour = (2 * parseInt(last_selects[8].value) - parseInt(last_selects[3].value)) % 24

  # day overflow handling
  selects[5].value = parseInt(selects[5].value) + 1 if (endhour < parseInt(last_selects[8].value))

  # sets ends_at hour
  selects[8].value = ("0" + endhour).slice(-2)

document.addEventListener "page:change", ->
  addressSearch = new Bloodhound
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value')
    queryTokenizer: Bloodhound.tokenizers.whitespace
    limit: 7
    remote:
      url: "http://data.wien.gv.at/daten/OGDAddressService.svc/GetAddressInfo?Address=%QUERY&crs=EPSG:4326"
      filter: (addresses) ->
        addresses.features
      wildcard: '%QUERY'

  addressSearch.initialize()

  $('.typeahead').typeahead null,
    name: 'addresse'
    source: addressSearch
    displayKey: (data) ->
      data.properties.Adresse
    templates:
      suggestion: (data) ->
        "<div>#{data.properties.Adresse}</div>"
