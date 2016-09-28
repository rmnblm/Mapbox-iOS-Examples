//
//  MarkerSelectFeedbackViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class MarkerSelectFeedbackViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 47.223272, longitude: 8.81734)
        point.title = "University of Applied Sciences Rapperswil"
        point.subtitle = "Where magic happens ✨"
        
        mapView.addAnnotation(point)
    }
    
    // MARK: - MGLMapViewDelegate methods
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        let reuseIdentifier = "HSRMarker"
        
        // For better performance, always try to reuse existing annotations
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one
        if annotationView == nil {
            annotationView = MarkerSelectFeedbackAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            annotationView!.backgroundColor = UIColor.orange
        }
        
        return annotationView
    }
    
    public func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        showAlert(title: "Annotation selected", message: "")
    }
    
    public func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        showAlert(title: "Annotation unselected", message: "")
    }
    
    public func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    public func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> UIView? {
        return MarkerSelectFeedbackCalloutView(annotation: annotation)
    }
    
    public func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
