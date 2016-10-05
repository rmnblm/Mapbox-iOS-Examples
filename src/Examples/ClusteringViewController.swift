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
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        loadData()
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "mcdonalds", withExtension: "geojson")!
        
        let options = [MGLGeoJSONClusterOption: true,
                       MGLGeoJSONClusterRadiusOption: 50,
                       MGLGeoJSONClusterMaximumZoomLevelOption: 12] as [String : Any]
        
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "mcdonalds", url: geoJSONURL, options: options)
        mapView.style().add(geoJSONSource)
        
        let layers = [[300.0, UIColor(colorLiteralRed: 229/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1)],
                      [150.0, UIColor(colorLiteralRed: 249/255.0, green: 136/255.0, blue: 108/255.0, alpha: 1)],
                      [0.0, UIColor(colorLiteralRed: 251/255.0, green: 176/255.0, blue: 59/255.0, alpha: 1)]]
        
        for index in 0..<layers.count {
            let circles = MGLCircleStyleLayer(layerIdentifier: "cluster-\(index)", source: geoJSONSource)
            circles.circleColor = layers[index][1] as! UIColor
            circles.circleRadius = 12 as MGLStyleAttributeValue!
            
            let gtePredicate = NSPredicate(format: "%K >= %@", argumentArray: ["point_count", layers[index][0] as! NSNumber])
            let allPredicate = index == 0 ?
                gtePredicate :
                NSCompoundPredicate(andPredicateWithSubpredicates: [gtePredicate, NSPredicate(format: "%K < %@", argumentArray: ["point_count", layers[index - 1][0] as! NSNumber])])
            
            circles.predicate = allPredicate
            
            mapView.style().add(circles)
        }
    }
}
