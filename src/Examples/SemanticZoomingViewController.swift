//
//  SemanticZoomingViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class SemanticZoomingViewController: UIViewController, MGLMapViewDelegate {
    
    private let dataSource = SemanticZoomingDataSource()
    
    @IBOutlet var mapView: MGLMapView!
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        loadData()
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "siliconvalley", withExtension: "geojson")!
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "sv", url: geoJSONURL)
        mapView.style().add(geoJSONSource)
        
        for layer in dataSource.layers {
            add(layer: layer)
        }
    }
    
    private func add(layer: SemanticZoomingLayer) {
        let styleLayer = MGLCircleStyleLayer(layerIdentifier: layer.title, sourceIdentifier: "sv")!
        styleLayer.predicate = layer.predicate
        styleLayer.circleColor = layer.color
        styleLayer.minimumZoomLevel = layer.minimumZoomLevel
        mapView.style().add(styleLayer)
        
        layer.styleLayer = styleLayer
    }
}
