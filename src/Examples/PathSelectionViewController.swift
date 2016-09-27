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
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        drawPoints()
        drawLines()
    }
    
    private func drawLines() {
        
        let geoJSONURL = Bundle.main.url(forResource: "portland", withExtension: "geojson")!
        
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "portland", url: geoJSONURL)
        mapView.style().add(geoJSONSource)
        
        let styleLayer = MGLLineStyleLayer(layerIdentifier: "portland-layer", sourceIdentifier: "portland")!
        styleLayer.lineWidth = 5 as MGLStyleAttributeValue!
        styleLayer.lineColor = UIColor.blue as MGLStyleAttributeValue!
        mapView.style().add(styleLayer)
    }
    
    private func drawPoints() {
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
                        
                        for (index, _) in coordinates.enumerated() {
                            if index == 0 { continue } // skip first
                            self.split(coordinates[index - 1], coordinates[index])
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
    
    private func add(coordinate: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            // Unowned reference to self to prevent retain cycle
            [unowned self] in
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = "Marker selected"
            point.subtitle = "\(coordinate.latitude) / \(coordinate.longitude)"
            self.mapView.addAnnotation(point)
        }
    }
    
    private func split(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) {
        if distance(from, to) > 200 { // THRESHOLD is 200m
            let middle = mid(from, to)
            add(coordinate: middle)
            split(from, middle)
            split(middle, to)
        }
        
        add(coordinate: from)
        add(coordinate: to)
    }
    
    private func distance(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> Double {
        let fromLoc = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLoc = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLoc.distance(from: toLoc)
    }
    
    private func mid(_ from: CLLocationCoordinate2D, _ to: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let latitude = (from.latitude + to.latitude) / 2
        let longitude = (from.longitude + to.longitude) / 2
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - MGLMapViewDelegate methods
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        let reuseIdentifier = annotation.subtitle!!
        
        // For better performance, always try to reuse existing annotations
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one
        if annotationView == nil {
            annotationView = PathSelectionAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect.init(x: 0, y: 0, width: 12, height: 12)
            annotationView!.backgroundColor = UIColor.clear
        }
        
        return annotationView
    }
    
    public func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
