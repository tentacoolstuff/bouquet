var z = 0;
var mLabels;
var mData0;
var mData1;
var mData2;
var chartsRendered = false;
var humidityChart;
var soilTempChart;
var chartWidth;
var valveState = false;

//pretty visuals 
function initViz(id,num){
    $.ajax({
        type: "GET",
        dataType: "json",
        url: "/dandelions/"+id,
        success: function(data){
            //humidity
            console.log(data);
            var hLabels = humidityData.labels;
            var hData = humidityData.datasets[0].data;
            //soil temp
            var sLabels = soilTempData.labels;
            var sData0 = soilTempData.datasets[0].data;
            var sData1 = soilTempData.datasets[1].data;
            var sData2 = soilTempData.datasets[2].data;
            //moisture
            mLabels = soilTempData.labels;
            mData0 = soilTempData.datasets[0].data;
            mData1 = soilTempData.datasets[1].data;
            mData2 = soilTempData.datasets[2].data;
            //update
            updateHumidityData(data,hData,hLabels,num);
            updateSoilTempData(data,sData0,sData1,sData2,sLabels,num);
            updateMoisData(data,mData0, mData1, mData2, mLabels,num);
            initMois(num);

            drawHumidityCharts(humidityData, soilTempData,num);
            
        }
  });
    function test(data,num,hLabels,hData){
        originalLength = humidityChart.datasets[0].bars.length; //intiial length
        goalLength = originalLength;
        chartWidth = humidityChart.scale.width;
        //if greater than goal length, reduce 
        if (originalLength >= num){
            humidityChart.datasets[0].bars.length = num;
            humidityChart.scale.xLabels.length = num;
            goalLength = num;
        }
        for (var i = 0; i < goalLength; i++){
            z = i + 1;
            hLabels[i] = z;
            hData[i] = data[i].humidity;
            humidityChart.datasets[0].bars[i].value = hData[i];
            humidityChart.scale.xLabels[i] = hLabels[i]
        }
        if(originalLength < num){
            for (var j = goalLength; j<num; j++){
                z = j+1;
                var temp = new Array();
                temp.push(hData[j]);
                humidityChart.addData(temp,z);
            }
        }
        humidityChart.update();
    }

    function updateHumidityData(data,hData,hLabels,num){
        hLabels.length = num;
        hData.length = num;
        console.log('num is'+ num);
        console.log('data length is '+data.length);
        for (var i = 0; i < num; i++){
            z = i + 1;
            hLabels[i] = z;
            hData[i] = data[i].humidity;
            //humidityChart.datasets[0].bars[i].value = hData[i];
        }
        humidityData.datasets[0].data = hData;
        humidityData.labels = hLabels;
    }
    function updateSoilTempData(data,sData0,sData1,sData2,sLabels,num){
        sLabels.length = num;
        sData0.length = num;
        sData1.length = num;
        sData2.length = num;
        for (var i = 0; i < num; i++){
            z = i + 1;
            sLabels[i] = z;
            sData0[i] = data[i].temperature1;
            sData1[i] = data[i].temperature2;
            sData2[i] = data[i].temperature3;
        }
        soilTempData.labels = sLabels;
        soilTempData.datasets[0].data = sData0;
        soilTempData.datasets[1].data = sData1;
        soilTempData.datasets[2].data = sData2;
    }
    function updateMoisData(data,mData0, mData1, mData2, mLabels,num){
        mLabels.length = num;
        mData0.length = num;
        mData1.length = num;
        mData2.length = num;
        for (var i = 0; i < num; i++){
            z = i + 1;
            mLabels[i] = z;
            mData0[i] = data[i].moisture1;
            mData1[i] = data[i].moisture2;
            mData2[i] = data[i].moisture3;
        }
    }

    function drawHumidityCharts(humidityData, soilTempData){
        $('#humidity-chart').remove();
        $('.humidity-trend').append('<canvas id="humidity-chart"></ canvas>');
        hCanvas = document.querySelector('#humidity-chart');
        hCtx = hCanvas.getContext('2d');

        $('#soil-temp-chart').remove();
        $('.soil-temp-trend').append('<canvas id="soil-temp-chart"></ canvas>');
        sCanvas = document.querySelector('#soil-temp-chart');
        sCtx = sCanvas.getContext('2d');


        humidityChart = new Chart(hCtx).Bar(humidityData);
        soilTempChart = new Chart(sCtx).Line(soilTempData,{
            datasetStrokeWidth : 3,
            pointDotRadius : 6,
            pointDotStrokeWidth : 3,
        });
    }
    function updateHumidityCharts(num){
        humidityChart.update();
        soilTempChart.update();
        console.log(humidityChart);
    }
    //initialize mositure tiles 
    function initMois(num){
        $('#moisTable').find(".row").remove();
        var row,col,rowid,colid;
        var tileColor = '<div class="cell-color"></div>';
        var tableWidth = $('#moisTable').width()-50;
        var tileWidth;
        if (num < 36){ tileWidth = tableWidth/(num+1);}
        else{tileWidth = tableWidth/(num+4)*2}
        
        var tileHeight = tileWidth;
        for(j=0;j<num;j++){
            row='<div id=\"row'+j+'\" class=\"row\"></div>';
            $('#moisTable').append(row);
            for(k=0;k<3;k++){
                col='<div id=\"col'+k+'\" class=\"column column-'+j+'\"></div>';
                $("#row"+j).append(col);
                if(k == 0){
                    $(".column-"+j+ "#col"+k).append(tileColor).css({
                        opacity:mData0[j]
                    });
                    $(".column-"+j+ "#col"+k+ " .cell-color").css("background-color", "#5993DB");

                }else if (k == 1){
                    $(".column-"+j+ "#col"+k).append(tileColor).css("opacity", mData1[j]);
                    $(".column-"+j+ "#col"+k+ " .cell-color").css("background-color", "#FFCA77");
                }else{
                    $(".column-"+j+ "#col"+k).append(tileColor).css("opacity", mData2[j]);
                    $(".column-"+j+ "#col"+k+ " .cell-color").css("background-color", "#63C4DC");
                }
            }
        }  
        //fixing tile width/height
        $('.column .cell-color').css({
            width: tileWidth,
            height: tileHeight,
            maxHeight: '35px'

        })
    }  

    var humidityContext = document.getElementById('humidity-chart').getContext('2d');;
    var soilTempContext = document.getElementById('soil-temp-chart').getContext('2d');;
    var grd = humidityContext.createLinearGradient(0, 200, 750, 50);
    grd.addColorStop(0, "#5797E3");
    grd.addColorStop(1, "#64CADC");

    var humidityData = {
        labels: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
        datasets: [
            {
                label: "Humidity Data",
                fillColor: grd,
                highlightFill: "rgba(47,143,212,1)",
                data: [65, 59, 80, 81, 56, 55, 40, 22,44,66],
                barValueSpacing : 1,
            }
        ]
    };

    var soilTempData = {
        labels: ["January", "February", "March", "April", "May", "June", "July"],
        datasets: [
            {
                label: "My First dataset",
                fillColor: "rgba(47,143,212,0.0)",
                strokeColor: "rgba(47,143,212,0.45)",
                pointColor: "rgba(47,143,212,1)",
                pointStrokeColor: "rgba(40,40,40,1.0)",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(40,40,40,1.0)",
                data: [65, 59, 80, 81, 56, 55, 40]
            },
            {
                label: "My Second dataset",
                fillColor: "rgba(255,204,123,0.0)",
                strokeColor: "rgba(255,204,123,0.45)",
                pointColor: "rgba(255,204,123,1)",
                pointStrokeColor: "rgba(40,40,40,1.0)",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(40,40,40,1.0)",
                data: [28, 48, 40, 19, 86, 27, 90]
            },
            {
                label: "My third dataset",
                fillColor: "rgba(99,196,220,0.0)",
                strokeColor: "rgba(99,196,220,0.45)",
                pointColor: "rgba(99,196,220,1)",
                pointStrokeColor: "rgba(40,40,40,1.0)",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(40,40,40,1.0)",
                data: [10, 38, 43, 49, 86, 37, 80]
            }
        ]
    };    
}

function buttonPressed(item){
    
    var dandPos = $(item).parent().parent().parent().index('.dandelion-listing-item');
    var irrigationStatus = ['No action needed', 'Irrigation in progress', 'Irrigation needed'];
    //var irrigationStarted = 
    var valveID = dandPos%4;
    console.log('valveID is ' + valveID);
    if (!valveState){
        valveState = true;
        $.ajax({
            url:"/dandelions/openValve",
            data: {valveID: valveID},
            dataType: 'script'
        });
        $.ajax("/dandelions/openValve");
        console.log('Opening valve');
        $(item).text('Irrigating').addClass('aButtonStyle');
        $(item).parent().parent().find('.irrigation-action').text(irrigationStatus[1]);

    }else{
        $.ajax({
            url:"/dandelions/closeValve",
            data: {valveID: valveID},
            dataType: 'script'
        });
        valveState = false;
        console.log('Closing valve');
        $(item).text('Irrigate');
        $(item).text('Irrigate').removeClass('aButtonStyle');
        $(item).parent().parent().find('.irrigation-action').text(irrigationStatus[0]);
        


    }
}
    








