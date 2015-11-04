# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).on 'ready', (event) ->
  if jQuery('#single-need-map').length
    lat = jQuery('#single-need-map').data('lat')
    long = jQuery('#single-need-map').data('long')
    map = new L.map('single-need-map')
    osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
    osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors'
    osm = new L.TileLayer osmUrl,
      minZoom: 8,
      maxZoom: 18,
      attribution: osmAttrib
    map.setView new L.LatLng(lat, long), 15
    map.addLayer osm
    marker = L.marker([lat, long]).addTo map
