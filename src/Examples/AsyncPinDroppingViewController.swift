//
//  ClusteringViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox
import SwiftyJSON

class AsyncPinDroppingViewController : UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        loadData()
    }
    
    private func loadData() {
        DispatchQueue.global().async { [unowned self] in
            do {
                let jsonPathUrl = Bundle.main.url(forResource: "mcdonalds", withExtension: "geojson")
                let jsonData = try Data(contentsOf: jsonPathUrl!)
                let json = JSON(data: jsonData)
                
                for feature in json["features"].arrayValue {    
                    if feature["geometry"]["type"].stringValue == "Point" {
                        if arc4random_uniform(50) != 0 { continue } // randomize and minimize data
                        
                        let coordinates = feature["geometry"]["coordinates"].arrayValue
                        
                        let point = MGLPointAnnotation()
                        point.coordinate = CLLocationCoordinate2D(latitude: coordinates[1].doubleValue, longitude: coordinates[0].doubleValue)
                        
                        DispatchQueue.main.async {
                            // Unowned reference to self to prevent retain cycle
                            [unowned self] in
                            self.mapView.addAnnotation(point)
                        }
                    }
                }
            }
            catch
            {
                print("GeoJSON parsing failed")
            }
        }
    }
}
