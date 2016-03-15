var map;
var detail;
var marker;
var infoArray = new Array();
var z;
var id;
var infowindow;

function initMap() {
	var mapDiv = document.getElementById('map');
  url = window.location.href;
  idArray = url.split('/').reverse();
  id = idArray[0];

	map = new google.maps.Map(mapDiv, {
  		center: {lat: 36.8689, lng: -119.7044},
  		zoom: 17,
      mapTypeId: google.maps.MapTypeId.HYBRID
	});

  $.ajax({
    type: "GET",
    dataType: "json",
    url: "/dandelions",
    success: function(data){
      console.log(data)
      if (id.length >=30){
        for (var j = 0; j<data.length; j++){
          if(id.indexOf(data[j].id)==0){
            loadMarker(data[j],j+1);
            break;
          }
        }
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

//individual marker
function loadMarker(data,z){
    var latLng = new google.maps.LatLng(data.lati,data.longi);
    createMarker(latLng,map,'title');
    popup = "Dandelion " + z;
    attachMessage(marker, popup);
    showMessage(marker, popup);

}

function createMarker(coords,map,title){
  marker = new google.maps.Marker({
    position: coords,
    map: map,
    title: title
  });
}

function attachMessage(marker, info) {
  infowindow = new google.maps.InfoWindow({
    content: info
  });

  marker.addListener('click', function() {
    infowindow.open(marker.get('map'), marker);

  });
}

function showMessage(marker, info){
  infowindow.open(marker.get('map'), marker);
}