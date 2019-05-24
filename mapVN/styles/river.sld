<?xml version="1.0" encoding="UTF-8"?><sld:UserStyle xmlns="http://www.opengis.net/sld" xmlns:sld="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:gml="http://www.opengis.net/gml">
<sld:Name>Default Styler</sld:Name>
<sld:FeatureTypeStyle>
  <sld:Name>name</sld:Name>
  <sld:Rule>
    <MaxScaleDenominator>1000000</MaxScaleDenominator>
    <sld:PolygonSymbolizer>
      <sld:Fill>
        <sld:CssParameter name="fill">#4a4aff</sld:CssParameter>
      </sld:Fill>
    </sld:PolygonSymbolizer>
    <sld:LineSymbolizer>
      <sld:Stroke>
        <sld:CssParameter name="stroke">#4a4aff</sld:CssParameter>
        <sld:CssParameter name="stroke-width">0.5</sld:CssParameter>
      </sld:Stroke>
    </sld:LineSymbolizer>
  </sld:Rule>
  <sld:Rule>
    <MaxScaleDenominator>10000</MaxScaleDenominator>
    <TextSymbolizer>
      <Label>
        <ogc:PropertyName>name</ogc:PropertyName>
      </Label>
      <Font>
        <CssParameter name="font-family">Times New Roman</CssParameter>
        <CssParameter name="font-size">14</CssParameter>
        <CssParameter name="font-style">normal</CssParameter>
      </Font>
      <LabelPlacement>
        <PointPlacement>
          <AnchorPoint>
            <AnchorPointX>0.5</AnchorPointX>
            <AnchorPointY>0.5</AnchorPointY>
          </AnchorPoint>
        </PointPlacement>
      </LabelPlacement>
      <Fill>
        <CssParameter name="fill">#000000</CssParameter>
      </Fill>
      <VendorOption name="partials">false</VendorOption>
    </TextSymbolizer>
  </sld:Rule>
</sld:FeatureTypeStyle>
</sld:UserStyle>