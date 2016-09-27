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
        addLayers()
        revalidateLayers()
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "siliconvalley", withExtension: "geojson")!
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "sv", url: geoJSONURL)
        mapView.style().add(geoJSONSource)
    }
    
    private func addLayer(layer: SemanticZoomingLayer) {
        let styleLayer = MGLCircleStyleLayer(layerIdentifier: layer.title, sourceIdentifier: "sv")!
        styleLayer.predicate = layer.predicate
        styleLayer.circleColor = layer.color
        mapView.style().add(styleLayer)
        
        layer.styleLayer = styleLayer
    }
    
    public func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        revalidateLayers()
    }
    
    private func addLayers() {
        for layer in dataSource.layers {
            addLayer(layer: layer)
        }
    }
    
    private func revalidateLayers() {
        for layer in dataSource.layers {
            layer.validate(zoomLevel: mapView.zoomLevel)
        }
    }
}
