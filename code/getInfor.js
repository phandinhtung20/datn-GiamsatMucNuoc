/* map.on('singleclick', function (evt) {
        var view = map.getView();
        var viewResolution = view.getResolution();
        var source = currentMap.getSource();
        const url = source.getGetFeatureInfoUrl(
            evt.coordinate,
            viewResolution,
            view.getProjection(),
            {
                'INFO_FORMAT': 'application/json',
                'FEATURE_COUNT': 50
            }
        );
        if (url) {
            $.ajax({
                type: 'POST',
                url: url,
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (n) {
                    if (n.features.length === 0) {
                        return;
                    }
                    var content = '<Span>';
                    for (var i = 0; i < n.features.length; i++) {
                        var feature = n.features[i];
                        var featureAttr = feature.properties;
                        content += (featureAttr['name_0'] ? 'Quốc gia: ' + featureAttr['name_0'] : '')
                            + (featureAttr['name_1'] ? '</br>Tỉnh/thành phố: ' + featureAttr['name_1'] : '')
                            + (featureAttr['name_2'] ? '</br>Quận/Huyện: ' + featureAttr['name_2'] : '')
                            + (featureAttr['name_3'] ? '</br>Phường xã: ' + featureAttr['name_3'] : '')
                            + (featureAttr['name'] ? 'Tên: ' + featureAttr['name'] : '')
                            + '</br>'
                    }
                    content += '</span>';
                    var vectorSource = new ol.source.Vector({
                        features: (new ol.format.GeoJSON()).readFeatures(n)
                    });
                    vectorLayer.setSource(vectorSource);

                    $('#popup-content').html(content);
                    overlay.setPosition(evt.coordinate);
                }
            });
        }
    }); */