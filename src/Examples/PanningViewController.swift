//
//  PanningViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class PanningViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        loadData()
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "mcdonalds", withExtension: "geojson")!
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "mcd", url: geoJSONURL)
        mapView.style().add(geoJSONSource)
        
        let styleLayer = MGLCircleStyleLayer(layerIdentifier: "mcd-layer", source: geoJSONSource)
        styleLayer.circleColor = UIColor.orange
        styleLayer.circleRadius = 5 as MGLStyleAttributeValue!
        mapView.style().add(styleLayer)
    }
}

