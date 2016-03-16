var map;
var detail;
var infoArray = new Array();
var id;
var heatmapData = new Array();
var returnData;
var temp;
var heatmap;
var ajaxData;
var markerList = new Array();
var infoWindowList = new Array();
var hoverState;
var gradient = [
  'rgba(225, 210, 0, 0)',
  'rgba(225, 210, 0, 1)',
  'rgba(250, 170, 0, 1)',
  'rgba(250, 140, 0, 1)',
  'rgba(250, 70, 0, 1)',
  'rgba(250, 40, 0, 1)',
]

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
      returnData = setHeatmap(data);
      ajaxData = data;
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
    },async: false
  });
  heatmap = new google.maps.visualization.HeatmapLayer({  
    data: returnData
  });
  heatmap.setOptions({
       //apply the gradient
       gradient: heatmap.get('gradient') ? null : gradient,
       // set other options
       //maxIntensity: 1, //The maximum intensity of the heatmap
       opacity: 0.7, //The opacity of the heatmap
       radius: 120, //The radius of influence for each data point, in pixels.
       //dissipating: true    //Specifies whether heatmaps dissipate on zoom
  });

}
function showHeatMap(){
  heatmap.setMap(map);
  hideMarkers();
}
function hideHeatMap(){
  heatmap.setMap(null);
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
    markerList[i]=marker;
    z = i+1;
    popup = "Dandelion #" + z;
    attachMessage(marker, popup,i);
  }
}

//load individual marker
function loadMarker(data,x){
    var latLng = new google.maps.LatLng(data.lati,data.longi);
    var marker = new google.maps.Marker({
      position: latLng,
      map: map,
      title: 'title',
      id: 'map-markers'
    });
    popup = "Dandelion " + x;
    attachMessage(marker, popup);
    showMessage(marker, x-1);
}

function hideMarkers(){
  for (m in markerList){
    markerList[m].setVisible(false);
  }
} 

function showMarkers(){
  for (m in markerList){
    markerList[m].setVisible(true);
  }
} 


function attachMessage(marker, info,i) {
  var infowindow = new google.maps.InfoWindow({
    content: info
  });
  infoWindowList.push(infowindow);
  marker.addListener('mouseover', function(){
    infowindow.open(marker.get('map'), marker);
    $('.dandelion-listing-item').eq(i).addClass('highlights');
    hoverState = true;
  });
  marker.addListener('mouseout', function(){
    if(hoverState){
      infowindow.close();
      $('.dandelion-listing-item').eq(i).removeClass('highlights');
      hoverState = false;
    }
     
  });


}

function showMessage(marker, x){
  infoWindowList[x].open(marker.get('map'), marker);
}

function hideMessages(){
  for (x in infoWindowList){
    infoWindowList[x].close();
  }
  
}
function setHeatmap(dData){
  var hLati = new Array();
  var hLongi = new Array();
  var hId = new Array();
  var hMois0 = new Array();
  var hMois1 = new Array();
  var hMois2 = new Array();
  var avgMois = new Array();
  var heatMapData = new Array();
  var point;
  for (var i = 0; i<dData.length; i++){
    hLongi[i] = dData[i].longi; 
    hLati[i] = dData[i].lati; 
    hId[i] = dData[i].id;
    $.ajax({
      type: "GET",
      dataType: "json",
      url: "/dandelions/"+hId[i],
      success: function(data){ 
        hMois0[i] = data[0].moisture1;
        hMois1[i] = data[0].moisture2;
        hMois2[i] = data[0].moisture3;
      },async:false
    });
    avgMois = (parseFloat(hMois0[i])+parseFloat(hMois1[i])+parseFloat(hMois2[i]))/2;
    heatmapData.push({location: new google.maps.LatLng(hLati[i],hLongi[i]), weight: avgMois});

  }
  return heatmapData;
} 