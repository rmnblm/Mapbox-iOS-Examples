//
//  MapboxStudioViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 28.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class MapboxStudioViewController: UIViewController, MGLMapViewDelegate {
    @IBOutlet var mapView: MGLMapView!
    
    override func viewDidLoad() {
        mapView.styleURL = URL(string: "mapbox://styles/rmnblm/citmz4g7100172infzbvtgxmi")
        let center = CLLocationCoordinate2D(latitude: 37.383925, longitude: -122.07135)
        mapView.setCenter(center, zoomLevel: 11.0, animated: false)
    }
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        print("didFinishLoading")
    }
    
    public func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
        print("didSelectAnnotationView")
    }
    
    public func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        print("didSelectAnnotation")
    }
    
    public func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
