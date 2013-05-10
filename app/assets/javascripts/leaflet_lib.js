var LeafletLib = LeafletLib || {};
var LeafletLib = {

    latmin: 90,
    latmax: -90,
    lngmin: 180,
    lngmax: -180,
    searchRadius: 805,
    defaultCity: "",
    markers: [ ],

    initialize: function(element, features, centroid, zoom) {

        LeafletLib.map = L.map(element).setView(new L.LatLng( centroid[0], centroid[1] ), zoom);

        LeafletLib.tiles = L.tileLayer('http://{s}.tiles.mapbox.com/v3/mapmeld.map-uyl6ixjz/{z}/{x}/{y}.png')
          .addTo(LeafletLib.map);

        LeafletLib.map.attributionControl.setPrefix('');
        L.Icon.Default.imagePath = "/assets/images/";

        if(typeof features.markers != "undefined"){
          for(var m=0;m<features.markers.length;m++){
            var pt = new L.LatLng( features.markers[m][0], features.markers[m][1] );
            new L.Marker( pt ).addTo( LeafletLib.map );
            LeafletLib.addBoundedPoint( pt );
          }
        }
        if(typeof features.geojson != "undefined"){
          LeafletLib.geojson = L.geoJson(features.geojson, {
              style: LeafletLib.style
          }).addTo(LeafletLib.map);

          LeafletLib.addBoundedBox( LeafletLib.geojson.getBounds() );
        }

        LeafletLib.fitFeatures();

    },

    style: function(feature) {
        return {
            weight: 2,
            opacity: 1,
            color: 'white',
            dashArray: '3',
            fillOpacity: 0.7,
            fillColor: '#FD8D3C'
        };
    },

    addBoundedPoint: function( latlng ){
        LeafletLib.latmin = Math.min( LeafletLib.latmin, latlng.lat );
        LeafletLib.latmax = Math.max( LeafletLib.latmax, latlng.lat );
        LeafletLib.lngmin = Math.min( LeafletLib.lngmin, latlng.lng );
        LeafletLib.lngmax = Math.max( LeafletLib.lngmax, latlng.lng );
    },

    addBoundedBox: function( bounds ){
        LeafletLib.latmin = Math.min( LeafletLib.latmin, bounds.getSouthWest().lat );
        LeafletLib.latmax = Math.max( LeafletLib.latmax, bounds.getNorthEast().lat );
        LeafletLib.lngmin = Math.min( LeafletLib.lngmin, bounds.getSouthWest().lng );
        LeafletLib.lngmax = Math.max( LeafletLib.lngmax, bounds.getNorthEast().lng );
    },

    fitFeatures: function(){
        if(LeafletLib.latmax > LeafletLib.latmin){
          var bounds = new L.LatLngBounds(
                      new L.LatLng( LeafletLib.latmin, LeafletLib.lngmin ),
                      new L.LatLng( LeafletLib.latmax, LeafletLib.lngmax ));

          LeafletLib.map.fitBounds( bounds.pad(.2) );
        }
    },

    squareAround: function(latlng, distance){
        var north = latlng.lat + distance * 0.000008;
        var south = latlng.lat - distance * 0.000008;
        var east = latlng.lng + distance * 0.000009;
        var west = latlng.lng - distance * 0.000009;
        var bounds = [[south, west], [north, east]];
        var sq = new L.rectangle(bounds);
        return sq;
    },

    searchAddress: function(address){
        if(LeafletLib.defaultCity && LeafletLib.defaultCity.length){
          var checkaddress = address.toLowerCase();
          var checkcity = LeafletLib.defaultCity.split(",")[0].toLowerCase();
          if(checkaddress.indexOf(checkcity) == -1){
            address += ", " + LeafletLib.defaultCity;
          }
        }
        var s = document.createElement("script");
        s.type = "text/javascript";
        s.src = "http://nominatim.openstreetmap.org/search/" + encodeURIComponent(address) + "?format=json&json_callback=LeafletLib.returnAddress";
        document.body.appendChild(s);
    },

    drawSquare: function(foundLocation, searchRadius){
        LeafletLib.sq = LeafletLib.squareAround(foundLocation, searchRadius);
        LeafletLib.sq.setStyle({
          strokeColor: "#4b58a6",
          strokeOpacity: 0.3,
          strokeWeight: 1,
          fillColor: "#4b58a6",
          fillOpacity: 0.1
        });
        LeafletLib.map.addLayer(LeafletLib.sq);

        LeafletLib.centerMark = new L.Marker(foundLocation, { icon: (new L.Icon({
          iconUrl: '/assets/blue-pushpin.png',
          iconSize: [32, 32],
          iconAnchor: [10, 32]
        }))}).addTo(LeafletLib.map);
    },

    returnAddress: function(response){
        //console.log(response);
        if(!response.length){
          alert("Sorry, no results found for that location.");
          return;
        }

        var first = response[0];
        var foundLocation = new L.LatLng(first.lat, first.lon);
        if(typeof LeafletLib.sq != "undefined" && LeafletLib.sq){
          LeafletLib.map.removeLayer(LeafletLib.sq);
          LeafletLib.map.removeLayer(LeafletLib.centerMark);
        }

        LeafletLib.drawSquare(foundLocation, LeafletLib.searchRadius);

        LeafletLib.filterMarkers( { rectangle: LeafletLib.sq } );

        LeafletLib.map.fitBounds( LeafletLib.sq.getBounds().pad(0.2) );
    },

    addMarker: function( marker ){
        LeafletLib.map.addLayer(marker);
        LeafletLib.addBoundedPoint( marker.getLatLng() );
        LeafletLib.markers.push( marker );
    },

    ptInShape: function( pt, shape ){
        if( typeof shape.rectangle != "undefined" ){
          var bounds = shape.rectangle.getBounds();
          if(pt.lat < bounds.getNorthEast().lat && pt.lat > bounds.getSouthWest().lat && pt.lng < bounds.getNorthEast().lng && pt.lng > bounds.getSouthWest().lng){
            return true;
          }
          return false;
        }
        else if( typeof shape.circle != "undefined" ){
          // getRadius is in meters, makes this more complex
        }
        else if( typeof shape.polygon != "undefined" ){
          var poly = shape.polygon.getLatLngs();
          for(var c = false, i = -1, l = poly.length, j = l - 1; ++i < l; j = i){
            ((poly[i].lat <= pt.lat && pt.lat < poly[j].lat) || (poly[j].lat <= pt.lat && pt.lat < poly[i].lat))
            && (pt.lng < (poly[j].lng - poly[i].lng) * (pt.lat - poly[i].lat) / (poly[j].lat - poly[i].lat) + poly[i].lng)
            && (c = !c);
          }
          return c;
       }
    },

    filterMarkers: function( boundary ){
        for(var m=0;m<LeafletLib.markers.length;m++){
          var ll = LeafletLib.markers[m].getLatLng();
          if(LeafletLib.ptInShape(ll, boundary)){
            if( !LeafletLib.map.hasLayer( LeafletLib.markers[m] ) ){
              LeafletLib.map.addLayer( LeafletLib.markers[m] );
            }
          }
          else{
            LeafletLib.map.removeLayer( LeafletLib.markers[m] );
          }
        }
    },

    geolocate: function(alt_callback){
        // Try W3C Geolocation
        var foundLocation;
        if(navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(function(position) {

            if(typeof alt_callback != "undefined"){
              alt_callback( position );
            }
            else{

              foundLocation = new L.LatLng(position.coords.latitude * 1.0, position.coords.longitude * 1.0);

              if(typeof LeafletLib.sq != "undefined" && LeafletLib.sq){
                LeafletLib.map.removeLayer(LeafletLib.sq);
                LeafletLib.map.removeLayer(LeafletLib.centerMark);
              }

              LeafletLib.drawSquare(foundLocation, LeafletLib.searchRadius);

              LeafletLib.filterMarkers( { rectangle: LeafletLib.sq } );

              LeafletLib.map.fitBounds( LeafletLib.sq.getBounds().pad(0.2) );
            }
          }, null);
        }
        else {
          alert("Sorry, we could not find your location.");
        }
    },

    enableMarker: function(marker, photo){

      var points = "points";
      if (photo.score == 1) points = "point"

      var popup_content = "<img src='" + photo.image_url + "' width='204' height='204' style='height:204px;width:204px;'/>\
      <h4>\
      by <a href='/user/" + photo.username + "'>" + photo.username + "</a>\
      <br /><span class='badge'>" + photo.score + " " + points + " </span>\
      <a href='/categories/" + photo.tag + "'>\
        <span class='badge " + photo.tag + "'>#" + photo.tag + "</span>\
      </a>\
      </h4>\
      <p>" + photo.caption + "</p>";

      marker.bindPopup(popup_content);
      marker.on('click', function(e){
        openMarker(marker, photo);
      });
      marker.on('mouseover', function(e){
        if($(".leaflet-popup").length == 0){
          e.latlng = marker.getLatLng();
          marker.fireEvent('click', e);
        }
      });
    }
}
