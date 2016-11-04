//
//  ClusteringViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class ClusteringViewController: UIViewController {
    
    @IBOutlet var mapView: MGLMapView!
    
    let clusterLayers = [[1000.0, UIColor(colorLiteralRed: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1), 28.0],
                         [300.0, UIColor(colorLiteralRed: 255/255.0, green: 149/255.0, blue: 0/255.0, alpha: 1), 24.0],
                         [100.0, UIColor(colorLiteralRed: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1), 18.0],
                         [0.0, UIColor(colorLiteralRed: 76/255.0, green: 217/255.0, blue: 100/255.0, alpha: 1), 15.0]]
    
    func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "mcdonalds", withExtension: "geojson")!
        
        var options = [String : Any]()
        options[MGLGeoJSONClusterOption] = true
        options[MGLGeoJSONClusterRadiusOption] = 42
        options[MGLGeoJSONClusterMaximumZoomLevelOption] = 20
        options[MGLGeoJSONMaximumZoomLevelOption] = 20
        options[MGLGeoJSONToleranceOption] = 0.42
        
        let geoJSONSource = MGLGeoJSONSource(identifier: "mcdonalds", url: geoJSONURL, options: options)
        mapView.style().add(geoJSONSource)
        
        for index in 0..<clusterLayers.count {
            let gtePredicate = NSPredicate(format: "%K >= %@", argumentArray: ["point_count", clusterLayers[index][0] as! NSNumber])
            let allPredicate = index == 0 ?
                gtePredicate :
                NSCompoundPredicate(andPredicateWithSubpredicates: [gtePredicate, NSPredicate(format: "%K < %@", argumentArray: ["point_count", clusterLayers[index - 1][0] as! NSNumber])])
            
            let circleBorder = MGLCircleStyleLayer(identifier: "cluster-\(index)-border", source: geoJSONSource)
            circleBorder.circleColor = MGLStyleConstantValue(rawValue: UIColor.white)
            let radius = clusterLayers[index][2] as! Double * 1.2
            circleBorder.circleRadius = MGLStyleConstantValue(rawValue: radius as NSNumber)
            circleBorder.predicate = allPredicate
            mapView.style().add(circleBorder)
            
            let circle = MGLCircleStyleLayer(identifier: "cluster-\(index)", source: geoJSONSource)
            circle.circleColor = MGLStyleConstantValue(rawValue: clusterLayers[index][1] as! UIColor)
            let radius2 = clusterLayers[index][2] as! Double
            circle.circleRadius = MGLStyleConstantValue(rawValue: radius2 as NSNumber)
            circle.predicate = allPredicate
            mapView.style().add(circle)
        }
        
        let clusterPointCountLayer = MGLSymbolStyleLayer(identifier: "cpc-layer", source: geoJSONSource)
        clusterPointCountLayer.textField = MGLStyleConstantValue(rawValue: "{point_count}")
        clusterPointCountLayer.textColor = MGLStyleConstantValue(rawValue: UIColor.white)
        mapView.style().add(clusterPointCountLayer)
    }
}

extension ClusteringViewController : MGLMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        loadData()
    }
}
