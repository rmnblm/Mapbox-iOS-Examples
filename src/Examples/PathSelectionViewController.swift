//
//  PathSelectionViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox
import SwiftyJSON

class PathSelectionViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        drawPolyline()
    }
    
    private func drawPolyline() {
        DispatchQueue.global().async { [unowned self] in
            do {
                let jsonPathUrl = Bundle.main.url(forResource: "portland", withExtension: "geojson")
                let jsonData = try Data(contentsOf: jsonPathUrl!)
                let json = JSON(data: jsonData)
                
                for feature in json["features"].arrayValue {
                    if feature["geometry"]["type"].stringValue == "LineString" {
                        
                        var coordinates = [CLLocationCoordinate2D]()
                        
                        for location in feature["geometry"]["coordinates"].arrayValue {
                            let coordinate = CLLocationCoordinate2DMake(location[1].doubleValue, location[0].doubleValue)
                            coordinates.append(coordinate)
                        }
                        
                        let line = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
                        line.title = feature["properties"]["name"].stringValue
                        
                        DispatchQueue.main.async {
                            // Unowned reference to self to prevent retain cycle
                            [unowned self] in
                            self.mapView.addAnnotation(line)
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
