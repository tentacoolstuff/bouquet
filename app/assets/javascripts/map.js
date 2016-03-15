var map;
var detail;
var infoArray = new Array();
//var z;
var id;
//var infowindow;

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
            console.log('loading individual marker');
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

//load all markers
function loadMarkers(data){
  for (var i = 0; i < data.length; i++) {
    var latLng = new google.maps.LatLng(data[i].lati,data[i].longi);
    var marker = new google.maps.Marker({
      position: latLng,
      map: map,
      title: 'title'
    });
    z = i+1;
    popup = "Dandelion #" + z;
    attachMessage(marker, popup);
  }
}

//load individual marker
function loadMarker(data,x){
    var latLng = new google.maps.LatLng(data.lati,data.longi);
    createMarker(latLng,map,'title');
    popup = "Dandelion " + x;
    attachMessage(marker, popup);
    //showMessage(marker, popup);

}

function attachMessage(marker, info) {
  var infowindow = new google.maps.InfoWindow({
    content: info
  });
  console.log('info is'+ info);
  //showMessage(marker, info);

  marker.addListener('click', function() {
    infowindow.open(marker.get('map'), marker);
  });
  marker.addListener('mouseover', function(){
    infowindow.open(marker.get('map'), marker);
  });

}

function showMessage(marker, info){
  infowindow.open(marker.get('map'), marker);
}