var format = 'image/png';
const url = 'http://localhost:8080/geoserver/mapVN/wms';
const urlRegister = 'http://localhost:3000/register';
const serviceFail = 'Dịch vụ nào đó không hoạt động';
var textRegister = 'Đăng ký nhận thông tin';
var textLoading = 'Đang kiểm tra...';
var emailRegex = new RegExp('^[a-z][a-z0-9_\.]{5,32}@[a-z0-9]{2,}(\.[a-z0-9]{2,4}){1,2}$');



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
var currentMap = VietNamProvince;

const listMapProps = [
    {
        name: 'mapLakes',
        config: {
            'LAYERS': 'mapVN:da_nang_lake',
            'tilesOrigin': 108.025094383 + "," + 15.9367961900001
        }
    },
    {
        name: 'mapRiver',
        config: {
            'LAYERS': 'mapVN:da_nang_river',
            'tilesOrigin': 107.919005706 + "," + 15.93324852
        }
    },
    {
        name: 'mapRoads',
        config: {
            'LAYERS': 'mapVN:test_style',
            'tilesOrigin': 107.857765197754 + "," + 15.9306573867798
        }
    },
    {
        name: 'mapPoints',
        config: {
            'LAYERS': 'mapVN:da_nang_point',
            'tilesOrigin': 103.134300231934 + "," + 8.5313606262207
        }
    },
    {
        name: 'mapSensor',
        config: {
            'LAYERS': 'mapVN:da_nang_point_sensor',
            'tilesOrigin': 103.134300231934 + "," + 8.5313606262207
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
    item.setVisible(true);
    listMapOptions.push(item);
}