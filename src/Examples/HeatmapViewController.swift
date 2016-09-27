//
//  ClusteringViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class HeatmapViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        loadData()
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "earthquakes", withExtension: "geojson")!
        
        let options = [MGLGeoJSONClusterOption: true,
                       MGLGeoJSONClusterRadiusOption: 20,
                       MGLGeoJSONClusterMaximumZoomLevelOption: 15] as [String : Any]
        
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "earthquakes", url: geoJSONURL, options: options)
        mapView.style().add(geoJSONSource)
        
        let symbolLayer = MGLSymbolStyleLayer(layerIdentifier: "place-city-sm", sourceIdentifier: "earthquakes")!
        mapView.style().add(symbolLayer)
        
        let unclusteredLayer = MGLCircleStyleLayer(layerIdentifier: "unclustered", sourceIdentifier: "earthquakes")!
        unclusteredLayer.circleColor = UIColor(colorLiteralRed: 229/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1)
        unclusteredLayer.circleRadius = 20 as MGLStyleAttributeValue!
        unclusteredLayer.circleBlur = 15 as MGLStyleAttributeValue!
        unclusteredLayer.predicate = NSPredicate(format: "%K != YES", argumentArray: ["cluster"])
        mapView.style().insert(unclusteredLayer, below: symbolLayer)
        
        let layers = [[150.0, UIColor(colorLiteralRed: 229/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1)],
                      [20.0, UIColor(colorLiteralRed: 249/255.0, green: 136/255.0, blue: 108/255.0, alpha: 1)],
                      [0.0, UIColor(colorLiteralRed: 251/255.0, green: 176/255.0, blue: 59/255.0, alpha: 1)]]
        
        for index in 0..<layers.count {
            let circles = MGLCircleStyleLayer(layerIdentifier: "cluster-\(index)", sourceIdentifier: "earthquakes")!
            circles.circleColor = layers[index][1] as! UIColor
            circles.circleRadius = 70 as MGLStyleAttributeValue!
            circles.circleBlur = 1 as MGLStyleAttributeValue!
            
            let gtePredicate = NSPredicate(format: "%K >= %@", argumentArray: ["point_count", layers[index][0] as! NSNumber])
            let allPredicate = index == 0 ?
                gtePredicate :
                NSCompoundPredicate(andPredicateWithSubpredicates: [gtePredicate, NSPredicate(format: "%K < %@", argumentArray: ["point_count", layers[index - 1][0] as! NSNumber])])
            
            circles.predicate = allPredicate
            
            mapView.style().insert(circles, below: symbolLayer)
        }
    }
}
