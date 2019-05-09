var map = null;
var result = null;
var resultSearch = null;

$('#document').ready(function () {
    var currentCoordinateContext = null;
    var currentSensorSelect = null;
    /**
    * Elements that make up the popup.
    */
    const container = document.getElementById('popup');
    const contextMenu = document.getElementById('contextmenu');
    const closer = document.getElementById('popup-closer');
    /**
    * Create an overlay to anchor the popup to the map.
    */
    
    var overlay = new ol.Overlay(({
        element: container,
        autoPan: true,
        autoPanAnimation: {
            duration: 250
        }
    }));
    var overlayContextMenu = new ol.Overlay(({
        element: contextMenu,
        autoPan: true,
        autoPanAnimation: {
            duration: 250
        }
    }));

    closer.onclick = function () {
        overlay.setPosition(undefined);
        closer.blur();
        return false;
    };

    const listAreaMap = [VietNamMap, VietNamProvince];
    var projection = new ol.proj.Projection({
        code: 'EPSG:4326',
        units: 'm',
        axisOrientation: 'neu'
    });
    const viewSetup = new ol.View({
        center: [0, 0],
        zoom: 30,
        minZoom: 22,
        maxZoom: 35,
        projection: projection,
        extent: [101.77443, 8.24221, 109.50172, 24.00141]
    });
    
    var map = new ol.Map({
        target: 'map',
        layers: [...listAreaMap, ...listMapOptions],
        overlays: [overlay, overlayContextMenu],
        loadTilesWhileAnimating: true,
        view: viewSetup
    });

    var styles = {
        'MultiPolygon': new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: 'red',
                width: 3
            })
        })
    };
    
    var startPoint = new ol.Feature();
    var destPoint = new ol.Feature();
    var styleFunction = function (feature) {
        return styles[feature.getGeometry().getType()];
    };
    var vectorLayer = new ol.layer.Vector({
        style: styleFunction,
        source: new ol.source.Vector({
            features: [startPoint, destPoint]
        })
    });
    map.addLayer(vectorLayer);
    vectorLayer = new ol.layer.Vector({
        source: new ol.source.Vector({
            features: [startPoint, destPoint]
        })
    });
    map.addLayer(vectorLayer);

    var bounds = [108.04029968008399, 16.030824314802885, 108.2267046123743, 16.14266727375098];
    map.getView().fit(bounds, map.getSize());

    VietNamProvince.setVisible(true);
    VietNamMap.setVisible(false);

    var nodeBegin = 0;
    var nodeEnd = 0;

    // Map event
    map.on('singleclick', function (evt) {
        overlayContextMenu.setPosition(undefined);
    });

    map.on('moveend', function(evt) {
        var coor = map.getView().getCenter();
        // var new_num = num.toFixed(2);
        $('#zoomText').text(map.getView().getZoom());
        $('#xText').text(coor[0].toFixed(5));
        $('#yText').text(coor[1].toFixed(5));
    });

    // Right click handler
    map.getViewport().addEventListener('contextmenu', function (evt) {
        evt.preventDefault();
        currentCoordinateContext = map.getEventCoordinate(evt)
        overlayContextMenu.setPosition(currentCoordinateContext);

        if (listMapOptions[4].get('visible')) {
            setButtonRegister(true);
            var view = map.getView();
            var viewResolution = view.getResolution();
            var source = listMapOptions[4].getSource();
            var url = source.getGetFeatureInfoUrl(
              currentCoordinateContext, viewResolution, view.getProjection(),
              {'INFO_FORMAT': 'application/json', 'FEATURE_COUNT': 50});
            if (url) {
                $.ajax({
                    url: url,
                    contentType: "application/json; charset=utf-8",
                    dataType: 'json',
                    success: function (n) {
                        currentSensorSelect = n;
                        if (n && n.features && n.features[0] && n.features[0].id &&
                            n.features[0].properties  && n.features[0].properties.type === 1) {
                            setButtonRegister(false, false);
                        } else {
                            setButtonRegister(false, true);
                        }
                    }
                });
            }
        } else {
            setButtonRegister(false, true);
        }
    });

    // Html element event
    $("#btnFindFrom").click(function () {
        overlayContextMenu.setPosition(undefined);
        startPoint.setGeometry(new ol.geom.Point(currentCoordinateContext));
        $("#txtPoint1").val(currentCoordinateContext);
        getNodeRouting(currentCoordinateContext, true)
    });

    $("#btnFindTo").click(function () {
        overlayContextMenu.setPosition(undefined);
        destPoint.setGeometry(new ol.geom.Point(currentCoordinateContext));
        $("#txtPoint2").val(currentCoordinateContext);
        getNodeRouting(currentCoordinateContext, false)
    });

    $("#btnSolve").click(function () {
        if (!(nodeBegin && nodeEnd)) {
            alert("Vui lòng chọn điểm đi và đến trước.")
            return;
        }

        $.ajax({
            url: `http://localhost:8080/geoserver/wfs?SERVICE=WFS&version=1.0.0&REQUEST=GetFeature&typeName=mapVN:danang_shostest&viewparams=a:${nodeBegin};b:${nodeEnd};&outputformat=application/json`,
            context: document.body
        }).done(function (data) {
            console.log(JSON.stringify(data))
        });

        var params = {
            'FORMAT': format,
            'VERSION': '1.1.1',
            'tiled': true,
            'exceptions': 'application/vnd.ogc.se_inimage',
            'LAYERS': 'mapVN:danang_shostest',
            'tilesOrigin': 108.161534807393 + "," + 16.0780766303172,
            'viewparams': `a:${nodeBegin};b:${nodeEnd};`
        };
        // shortest distance
        result = new ol.layer.Tile({
            source: new ol.source.TileWMS({
                ratio: 1,
                url: url,
                params: params
            })
        });

        map.addLayer(result);
    });

    $("#btnReset").click(function () {
        startPoint.setGeometry(null);
        $("#txtPoint1").val("");
        destPoint.setGeometry(null);
        $("#txtPoint2").val("");
        nodeBegin = 0;
        nodeEnd = 0;
        map.removeLayer(result);
    });

    $('#selectArea').change(() => {
        currentMap = listAreaMap[$('#selectArea').val()];
        hideAllMap(listAreaMap);
        currentMap.setVisible(true);
    });
    
    $('.selectOption').change(() => {
        const indexSelected = listMapProps.findIndex((item) => {
            return item.name === event.target.name;
        });
        if (indexSelected >= 0) {
            listMapOptions[indexSelected].setVisible(event.target.checked);
        }
    });

    $('#search_button').click(()=>{
        map.getView().setCenter([106.82, 17]);
    });

    $('#input_search').keyup(function(e){
        if(e.keyCode == 13) {
            search($('#input_search').val())
        } else {

        }
    });

    $('#btnRegister').click(() => {
        let email = prompt('Nhập email muốn đăng ký', "tungtungg@sv.dut");

        if (email != null) {
            if (emailRegex.test(email)) {
                registerLocation(email);
            } else {
                alert('Email không hợp lệ');
            }
        }
    });

    $('#dashboard').click(() => {
        // show dashboard currentSensorSelect.features[0].id
        openForm();
    });

    $('#popup-dashboard-closer').click(() => {
        closeForm();
    });

    var getNodeRouting = (coordinate, isFirst) => {
        $.ajax({
            url: 'http://localhost:8080/geoserver/wfs?SERVICE=WFS&version=1.0.0&REQUEST=GetFeature&typeName=mapVN:danang_nearest&viewparams=x:'
            +coordinate[0]+';y:'+coordinate[1]+';&outputformat=application/json',
            context: document.body
        }).done(function (data) {
            if (data && data.features && data.features[0].properties && data.features[0].properties.id) {
                if (isFirst) {
                    nodeBegin = data.features[0].properties.id;
                } else {
                    nodeEnd = data.features[0].properties.id;
                }
                console.log(`nodeBegin: ${nodeBegin}, nodeEnd: ${nodeEnd}`);
            }
        });
    };

    var getNodeSensor = (coordinate, isFirst) => {
        $.ajax({
            url: 'http://localhost:8080/geoserver/wfs?SERVICE=WFS&version=1.0.0&REQUEST=GetFeature&typeName=mapVN:danang_nearest&viewparams=x:'
            +coordinate[0]+';y:'+coordinate[1]+';&outputformat=application/json',
            context: document.body
        }).done(function (data) {
            if (data && data.features && data.features[0].properties && data.features[0].properties.id) {
                if (isFirst) {
                    nodeBegin = data.features[0].properties.id;
                } else {
                    nodeEnd = data.features[0].properties.id;
                }
                console.log(`nodeBegin: ${nodeBegin}, nodeEnd: ${nodeEnd}`);
            }
        });
    };

    var search = (key) => {
        $.ajax({
            url: 'http://localhost:8081/?t='+key
        }).done(function (data) {
            if (data && data.code) {
                if ( data.code == 200) {
                    if (data.locations && data.locations.length > 0) {
                        resultSearch = data.locations;
                        let  result = '';
                        for (let i = 0; i < data.locations.length; i++) {
                            result += '<div onclick=showNode(\''+i+'\')><hr><span>' + data.locations[i].name + '</span>&nbsp;&nbsp;&nbsp;'
                                    + '<span class=\'text_smoke\'>' + data.locations[i].address + '</span>'+ '</div>'    
                        }

                        result += '<div onclick=hideSearch() id=\'hide_search\'>Ẩn</div>'

                        $('#result_search').html(result);
                    }
                } else {
                    alert('Error');                
                }
            } else{
                alert('Error');
            }
        }).fail(function() {
            alert(serviceFail);
        });
    }

    var setButtonRegister = (isLoading, isShow) => {
        if (isLoading) {
            $('#btnRegister').html(textLoading);
            $('#dashboard').prop('disabled', true);
        } else {
            $('#btnRegister').html(textRegister);
            $('#btnRegister').prop('disabled', isShow);
            $('#dashboard').prop('disabled', false);
        }
    }

    var registerLocation = (email) => {
        let formData = {
            'id': currentSensorSelect.features[0].id,
            'email': email
        };

        $.ajax({
            type: 'post',
            url: urlRegister,   
            data: formData,
            success: function (data) {
                if (data.status !== 200) {
                    alert('Đăng ký lỗi: ' + data.message);
                    console.log(data.message)
                }
            },  
            error: function () {
                console.log('We are sorry but our servers are having an issue right now');
            }
        })
    }

    hideSearch = () => {
        resultSearch = null;
        $('#result_search').html("");
    }

    showNode = (i) => {
        $("#popup-content").html(resultSearch[i].name);
        let coordinate = [resultSearch[i].lon,resultSearch[i].lat]
        overlay.setPosition(coordinate);

        map.getView().setCenter(coordinate);
        map.getView().setZoom(35);


        hideSearch();
    }

    hideAllMap(listMapOptions);

    listMapOptions[4].setVisible(true);

    function openForm() {
        document.getElementById("dashboard-popup-id").style.display = "block";
        document.getElementById('dashboard-div').innerHTML =
            '<iframe seamless id="iframe-dashboard" src="http://localhost:3000/dashboard/view/' +
            currentSensorSelect.features[0].id + '"></iframe>';
    }

    function closeForm() {
        document.getElementById("dashboard-popup-id").style.display = "none";
    }
});

hideAllMap = (listMap) => {
    for (let i = 0; i < listMap.length; i++) {
        listMap[i].setVisible(false);
    }
}