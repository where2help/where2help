document.addEventListener("page:change", function() {

  function checkForMap() {
    var $mapContainer = $("[data-behavior='map-container']");
    if($mapContainer.length) initMap($mapContainer);
  }

  function initMap(mapContainer) {
    var lat = mapContainer.data('lat');
    var long = mapContainer.data('long');
    var map = new L.map(mapContainer.attr('id'));
    var osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    var osmAttrib = 'Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
    var osm = new L.TileLayer(osmUrl, { minZoom: 8, maxZoom: 18, attribution: osmAttrib});
    map.setView(new L.LatLng(lat, long), 15);
    map.addLayer(osm);
    new L.marker([lat, long]).addTo(map);
  }

  checkForMap();
});
