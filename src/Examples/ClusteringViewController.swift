//
//  ClusteringViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class ClusteringViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "mcdonalds", withExtension: "geojson")!
        
        var options = [String : Any]()
        options[MGLGeoJSONClusterOption] = true
        options[MGLGeoJSONClusterRadiusOption] = 42
        options[MGLGeoJSONClusterMaximumZoomLevelOption] = 98
        options[MGLGeoJSONMaximumZoomLevelOption] = 99
        options[MGLGeoJSONToleranceOption] = 0.42
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "mcd", url: geoJSONURL, options: options)
        mapView.style().add(geoJSONSource)
        
        let styleLayer1 = MGLCircleStyleLayer(layerIdentifier: "mcd-layer1", sourceIdentifier: "mcd")!
        styleLayer1.circleColor = UIColor.orange
        styleLayer1.circleOpacity = 0.5 as MGLStyleAttributeValue!
        styleLayer1.circleRadius = 13 as MGLStyleAttributeValue!
        mapView.style().add(styleLayer1)
        
        let styleLayer2 = MGLCircleStyleLayer(layerIdentifier: "mcd-layer2", sourceIdentifier: "mcd")!
        styleLayer2.circleColor = UIColor.orange
        styleLayer2.circleRadius = 10 as MGLStyleAttributeValue!
        mapView.style().add(styleLayer2)
    }
}
