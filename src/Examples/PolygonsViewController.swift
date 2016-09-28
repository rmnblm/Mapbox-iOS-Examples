//
//  PolygonsViewController.swift
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
        loadData()
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "amsterdam", withExtension: "geojson")!
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "ams", url: geoJSONURL)
        mapView.style().add(geoJSONSource)
        let styleLayer = MGLFillStyleLayer(layerIdentifier: "ams-layer", sourceIdentifier: "ams")!
        styleLayer.fillColor = UIColor.purple
        styleLayer.fillOpacity = 0.5 as MGLStyleAttributeValue!
        styleLayer.fillOutlineColor = UIColor.purple
        mapView.style().add(styleLayer)
    }
    
}
