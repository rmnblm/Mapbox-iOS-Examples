//
//  PolygonsV$iewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class PolygonsViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        let geoJSONURL = Bundle.main.url(forResource: "amsterdam", withExtension: "geojson")!
        let geoJSONSource = MGLShapeSource(identifier: "ams", url: geoJSONURL)
        mapView.style?.addSource(geoJSONSource)
        let styleLayer = MGLFillStyleLayer(identifier: "ams-layer", source: geoJSONSource)
        styleLayer.fillColor = MGLStyleConstantValue(rawValue: UIColor.purple)
        styleLayer.fillOpacity = MGLStyleConstantValue(rawValue: 0.5)
        styleLayer.fillOutlineColor = MGLStyleConstantValue(rawValue: UIColor.purple)
        mapView.style?.addLayer(styleLayer)
    }
}
