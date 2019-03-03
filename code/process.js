var map = null;
var result = null;

$('#document').ready(function () {
    /**
    * Elements that make up the popup.
    */
    var container = document.getElementById('popup');
    var closer = document.getElementById('popup-closer');
    /**
    * Create an overlay to anchor the popup to the map.
    */
    var overlay = new ol.Overlay(/** @type {olx.OverlayOptions} */({
        element: container,
        autoPan: true,
        autoPanAnimation: {
            duration: 250
        }
    }));
    /**
    * Add a click handler to hide the popup.
    * @return {boolean} Don't follow the href.
    */
    closer.onclick = function () {
        overlay.setPosition(undefined);
        closer.blur();
        return false;
    };

    const listAreaMap = [VietNamMap, VietNamProvince, cacQuan, cacPhuong];
    var projection = new ol.proj.Projection({
        code: 'EPSG:3405',
        units: 'm',
        axisOrientation: 'neu'
    });
    const viewSetup = new ol.View({
        center: [0, 0],
        zoom: 30,
        minZoom: 20,
        maxZoom: 35,
        projection: projection
    });
    
    map = new ol.Map({
        target: 'map',
        layers: [...listAreaMap, ...listMapOptions],
        overlays: [overlay],
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

    //map.getView().fitExtent(bounds, map.getSize());
    var bounds = [108.04029968008399, 16.030824314802885, 108.2267046123743, 16.14266727375098];
    map.getView().fit(bounds, map.getSize());

    cacPhuong.setVisible(false);
    cacQuan.setVisible(false);
    VietNamProvince.setVisible(false);

    $('#selectArea').change(() => {
        currentMap = listAreaMap[$('#selectArea').val()];
        hideAllMap(listAreaMap);
        currentMap.setVisible(true);
    });
    
    $('.selectOption').change(() => {
        const indexSelected = listMapProps.findIndex((item) => {
            return item.name === event.target.name;
        });
        log(indexSelected);
        if (indexSelected >= 0) {
            listMapOptions[indexSelected].setVisible(event.target.checked);
        }
        log(event.target.checked);
    });

    var nodeBegin = 0;
    var nodeEnd = 0;

    map.on('singleclick', function (evt) {
        if (startPoint.getGeometry() == null) {
            // First click.
            startPoint.setGeometry(new ol.geom.Point(evt.coordinate));
            $("#txtPoint1").val(evt.coordinate);
            getNode(evt.coordinate, true)
        } else if (destPoint.getGeometry() == null) {
            // Second click.
            destPoint.setGeometry(new ol.geom.Point(evt.coordinate));
            $("#txtPoint2").val(evt.coordinate);
            getNode(evt.coordinate, false)
        }
    });
 
    $("#btnSolve").click(function () {
        if (!(nodeBegin && nodeEnd)) {
            alert("Vui lòng chọn điểm đi và đến trước.")
            return;
        }

        $.ajax({
            url: `http://localhost:8080/geoserver/wfs?SERVICE=WFS&version=1.0.0&REQUEST=GetFeature&typeName=mapVN:shortest&viewparams=a:${nodeBegin};b:${nodeEnd};&outputformat=application/json`,
            context: document.body
        }).done(function (data) {
            log(data)
        });

        var params = {
            'FORMAT': format,
            'VERSION': '1.1.1',
            'tiled': true,
            'exceptions': 'application/vnd.ogc.se_inimage',
            'LAYERS': 'mapVN:shortestLine',
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

    var getNode = (coordinate, isFirst) => {
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
                log(`nodeBegin: ${nodeBegin}, nodeEnd: ${nodeEnd}`);
            }
        });
    };
});
log = (x) => {
    console.log(x)
}

hideAllMap = (listMap) => {
    for (let i = 0; i < listMap.length; i++) {
        listMap[i].setVisible(false);
    }
}

showLevelZoom = () => {
    log(map.getView().getZoom())
}