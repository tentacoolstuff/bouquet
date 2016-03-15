var map;
var detail;
var marker;
var infoArray = new Array();
var z;
var id;



function initMap() {
	var mapDiv = document.getElementById('map');
  url = window.location.href;
  id = url.split('/').reverse();

	map = new google.maps.Map(mapDiv, {
  		center: {lat: 36.8689, lng: -119.7044},
  		zoom: 16
	});

  $.ajax({
    type: "GET",
    dataType: "json",
    url: "/dandelions",
    success: function(data){
      //loadMarkers(data);
      console.log(data)
      if (id[0].length >=30){
        loadMarker(data[0],0);
      }
      else{
        loadMarkers(data);
      }
    }


      

  });
}


function loadMarkers(data){
  for (var i = 0; i < data.length; i++) {
    var latLng = new google.maps.LatLng(data[i].lati,data[i].longi);
    createMarker(latLng,map,'title');
    z = i+1;
    popup = "Dandelion " + z;
    attachMessage(marker, popup);
  }
}

function loadMarker(data,z){
    var latLng = new google.maps.LatLng(data.lati,data.longi);
    createMarker(latLng,map,'title');
    popup = "Dandelion " + z;
    attachMessage(marker, popup);
}

function createMarker(coords,map,title){
  marker = new google.maps.Marker({
    position: coords,
    map: map,
    title: title
  });
}

function attachMessage(marker, info) {
  var infowindow = new google.maps.InfoWindow({
    content: info
  });

  marker.addListener('click', function() {
    infowindow.open(marker.get('map'), marker);

  });
}

function showMessage(marker, info){
  infowindow.open(marker.get('map'), marker);
}