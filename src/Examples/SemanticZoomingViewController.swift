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
    
    var mapLoaded = false
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapLoaded = true
        
        loadData()
        revalidateLayers()
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "siliconvalley", withExtension: "geojson")!
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "sv", url: geoJSONURL)
        mapView.style().add(geoJSONSource)
    }
    
    public func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        // Check if map is loaded, this won't be necessary in the future when issue #6361 is fixed
        // https://github.com/mapbox/mapbox-gl-native/issues/6361
        if mapLoaded {
            revalidateLayers()
        }
    }
    
    private func revalidateLayers() {
        for layer in dataSource.layers {
            if mapView.zoomLevel >= layer.visibleAt {
                if layer.styleLayer == nil {
                    add(layer: layer)
                }
            } else {
                if layer.styleLayer != nil {
                    mapView.style().remove(layer.styleLayer!)
                    layer.styleLayer = nil
                }
            }
        }
    }
    
    private func add(layer: SemanticZoomingLayer) {
        let styleLayer = MGLCircleStyleLayer(layerIdentifier: layer.title, sourceIdentifier: "sv")!
        styleLayer.predicate = layer.predicate
        styleLayer.circleColor = layer.color
        mapView.style().add(styleLayer)
        
        layer.styleLayer = styleLayer
    }
}
