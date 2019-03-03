var format = 'image/png';
const url = 'http://localhost:8080/geoserver/mapVN/wms';

// Map VN
var VietNamMap = new ol.layer.Tile({
    source: new ol.source.TileWMS({
        ratio: 1,
        url: url,
        params: {
            'FORMAT': format,
            'VERSION': '1.1.1',
            'LAYERS': 'mapVN:gadm36_vnm_0',
            'exceptions': 'application/vnd.ogc.se_inimage',
            tilesOrigin: 102.14458466 + ',' + 8.38135529
        }
    })
});
var currentMap = VietNamProvince;

// Viet Nam's province
var VietNamProvince = new ol.layer.Tile({
    source: new ol.source.TileWMS({
        ratio: 1,
        url: 'http://localhost:8080/geoserver/mapVN/wms',
        params: {
            'FORMAT': format,
            'VERSION': '1.1.1',
            'LAYERS': 'mapVN:gadm36_vnm_1',
            "exceptions": 'application/vnd.ogc.se_inimage',
            tilesOrigin: 102.107963562012 + "," + 8.30629825592041
        }
    })
});

// Viet Nam's commune
var cacPhuong = new ol.layer.Tile({
    source: new ol.source.TileWMS({
        ratio: 1,
        url: url,
        params: {
            'FORMAT': format,
            'VERSION': '1.1.1',
            'LAYERS': 'mapVN:gadm36_vnm_3',
            'exceptions': 'application/vnd.ogc.se_inimage',
            tilesOrigin: 102.144584655762 + "," + 8.38135433197021
        }
    })
});

// Viet Nam's district
var cacQuan = new ol.layer.Tile({
    source: new ol.source.TileWMS({
        ratio: 1,
        url: url,
        params: {
            'FORMAT': format,
            'VERSION': '1.1.1',
            'tiled': true,
            'LAYERS': 'cite:gadm36_vnm_2',
            'exceptions': 'application/vnd.ogc.se_inimage',
            tilesOrigin: 102.107963562012 + "," + 8.30629825592041
        }
    })
});

const listMapProps = [
    {
        name: 'mapRoads',
        config: {
            'LAYERS': 'mapVN:bk_road' // mapVN:roads',
            'tilesOrigin': 108.117286682129 + "," + 16.053352355957
        }
    },
    {
        name: 'mapPlaces',
        config: {
            'LAYERS': 'mapVN:places',
            'tilesOrigin': 102.129455566406 + ',' + 8.53203773498535
        }
    },
    {
        name: 'mapPoints',
        config: {
            'LAYERS': 'mapVN:points',
            'tilesOrigin': 103.134300231934 + "," + 8.5313606262207
        }
    },
    {
        name: 'mapRailWays',
        config: {
            'LAYERS': 'mapVN:railways',
            'tilesOrigin': 103.950614929199 + ',' + 10.7116680145264
        }
    },
    {
        name: 'mapRiver',
        config: {
            'LAYERS': 'mapVN:waterways',
            'tilesOrigin': 102.152709960938 + ',' + 8.49191284179688
        }
    },
    {
        name: 'mapLandUse',
        config: {
            'LAYERS': 'mapVN:landuse',
            tilesOrigin: 102.129455566406 + ',' + 8.53203773498535
        }
    },
    {
        name: 'mapBuilding',
        config: {
            'LAYERS': 'mapVN:buildings',
            tilesOrigin: 104.426597595215 + ',' + 8.35500335693359
        }
    },
    {
        name: 'mapNatural',
        config: {
            'LAYERS': 'mapVN:natural',
             tilesOrigin: 103.300170898438 + ',' + 8.494384765625
        }
    }
];

const listMapOptions = []; 
for (let i = 0; i < listMapProps.length; i++) {
    const item = new ol.layer.Tile({
        source: new ol.source.TileWMS({
            ratio: 1,
            url: url,
            params: {
                'FORMAT': format,
                'VERSION': '1.1.1',
                'tiled': true,
                'LAYERS': listMapProps[i].config.LAYERS,
                'exceptions': 'application/vnd.ogc.se_inimage',
                tilesOrigin: listMapProps[i].config.tilesOrigin
            }
        })
    });
    item.setVisible(false);
    listMapOptions.push(item);
}
