<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld"
                       xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <NamedLayer>
    <Name>default_polygon</Name>
    <UserStyle>
      <Title>Default Polygon</Title>
      <Abstract>A sample style that draws a polygon</Abstract>
      <FeatureTypeStyle>
        <Rule>
          <Name>rule1</Name>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#66FF66</CssParameter>
            </Fill>
            <Stroke>
              <CssParameter name="stroke">#000000</CssParameter>
              <CssParameter name="stroke-width">1</CssParameter>
            </Stroke>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Name>rule2</Name>
          <TextSymbolizer>
            <Label>
              <ogc:PropertyName>name_1</ogc:PropertyName>
            </Label>
            <Font>
              <CssParameter name="font-family">Arial</CssParameter>
              <CssParameter name="font-size">16</CssParameter>
              <CssParameter name="font-style">normal</CssParameter>
              <CssParameter name="font-weight">bold</CssParameter>
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
            <Halo>
              <Radius>1</Radius>
              <Fill>
                <CssParameter name="fill">#FFFFFF</CssParameter>
              </Fill>
            </Halo>
            <VendorOption name="partials">true</VendorOption>
          </TextSymbolizer>
        </Rule>
        <Rule>
          <Name>0</Name>
          <Title>div 1</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:Sub>
                <ogc:PropertyName>gid</ogc:PropertyName>
                <ogc:Mul>
                  <ogc:Function name="floor">
                    <ogc:Div>
                      <ogc:PropertyName>gid</ogc:PropertyName>
                      <ogc:Literal>10</ogc:Literal>
                    </ogc:Div>
                  </ogc:Function>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Mul>
              </ogc:Sub>
              <ogc:Literal>0</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#0c343d</CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>
        
        <Rule>
          <Name>1</Name>
          <Title>div 1</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:Sub>
                <ogc:PropertyName>gid</ogc:PropertyName>
                <ogc:Mul>
                  <ogc:Function name="floor">
                    <ogc:Div>
                      <ogc:PropertyName>gid</ogc:PropertyName>
                      <ogc:Literal>10</ogc:Literal>
                    </ogc:Div>
                  </ogc:Function>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Mul>
              </ogc:Sub>
              <ogc:Literal>1</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#20124d</CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Name>2</Name>
          <Title>div 1</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:Sub>
                <ogc:PropertyName>gid</ogc:PropertyName>
                <ogc:Mul>
                  <ogc:Function name="floor">
                    <ogc:Div>
                      <ogc:PropertyName>gid</ogc:PropertyName>
                      <ogc:Literal>10</ogc:Literal>
                    </ogc:Div>
                  </ogc:Function>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Mul>
              </ogc:Sub>
              <ogc:Literal>2</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#38761d</CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Name>3</Name>
          <Title>div 1</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:Sub>
                <ogc:PropertyName>gid</ogc:PropertyName>
                <ogc:Mul>
                  <ogc:Function name="floor">
                    <ogc:Div>
                      <ogc:PropertyName>gid</ogc:PropertyName>
                      <ogc:Literal>10</ogc:Literal>
                    </ogc:Div>
                  </ogc:Function>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Mul>
              </ogc:Sub>
              <ogc:Literal>3</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#cc0000</CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Name>4</Name>
          <Title>div 1</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:Sub>
                <ogc:PropertyName>gid</ogc:PropertyName>
                <ogc:Mul>
                  <ogc:Function name="floor">
                    <ogc:Div>
                      <ogc:PropertyName>gid</ogc:PropertyName>
                      <ogc:Literal>10</ogc:Literal>
                    </ogc:Div>
                  </ogc:Function>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Mul>
              </ogc:Sub>
              <ogc:Literal>9</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#d0e0e3</CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Name>5</Name>
          <Title>div 1</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:Sub>
                <ogc:PropertyName>gid</ogc:PropertyName>
                <ogc:Mul>
                  <ogc:Function name="floor">
                    <ogc:Div>
                      <ogc:PropertyName>gid</ogc:PropertyName>
                      <ogc:Literal>10</ogc:Literal>
                    </ogc:Div>
                  </ogc:Function>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Mul>
              </ogc:Sub>
              <ogc:Literal>5</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#660000</CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Name>6</Name>
          <Title>div 1</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:Sub>
                <ogc:PropertyName>gid</ogc:PropertyName>
                <ogc:Mul>
                  <ogc:Function name="floor">
                    <ogc:Div>
                      <ogc:PropertyName>gid</ogc:PropertyName>
                      <ogc:Literal>10</ogc:Literal>
                    </ogc:Div>
                  </ogc:Function>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Mul>
              </ogc:Sub>
              <ogc:Literal>6</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#ffd966</CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Name>7</Name>
          <Title>div 1</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:Sub>
                <ogc:PropertyName>gid</ogc:PropertyName>
                <ogc:Mul>
                  <ogc:Function name="floor">
                    <ogc:Div>
                      <ogc:PropertyName>gid</ogc:PropertyName>
                      <ogc:Literal>10</ogc:Literal>
                    </ogc:Div>
                  </ogc:Function>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Mul>
              </ogc:Sub>
              <ogc:Literal>7</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#9900ff</CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Name>8</Name>
          <Title>div 1</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:Sub>
                <ogc:PropertyName>gid</ogc:PropertyName>
                <ogc:Mul>
                  <ogc:Function name="floor">
                    <ogc:Div>
                      <ogc:PropertyName>gid</ogc:PropertyName>
                      <ogc:Literal>10</ogc:Literal>
                    </ogc:Div>
                  </ogc:Function>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Mul>
              </ogc:Sub>
              <ogc:Literal>2</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#7f6000</CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>
        <Rule>
          <Name>9</Name>
          <Title>div 1</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:Sub>
                <ogc:PropertyName>gid</ogc:PropertyName>
                <ogc:Mul>
                  <ogc:Function name="floor">
                    <ogc:Div>
                      <ogc:PropertyName>gid</ogc:PropertyName>
                      <ogc:Literal>10</ogc:Literal>
                    </ogc:Div>
                  </ogc:Function>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Mul>
              </ogc:Sub>
              <ogc:Literal>4</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#00ffff</CssParameter>
            </Fill>
          </PolygonSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>