//
//  PathSelectionViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class PathSelectionViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    var annotation: MGLPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if annotation != nil {
            mapView.removeAnnotation(annotation!)
        }
        
        let location = recognizer.location(in: mapView)
        let touchableSquare = squareFrom(location: location)
        for feature in mapView.visibleFeatures(in: touchableSquare, styleLayerIdentifiers: ["portland-layer"]) {
            
            print(feature)
            print(feature.attributes)
            
            if feature is MGLPolylineFeature {
                let lineFeature = feature as! MGLPolylineFeature
                
                annotation = MGLPointAnnotation()
                annotation!.coordinate = lineFeature.coordinate
                annotation!.title = lineFeature.title
                annotation!.subtitle = lineFeature.subtitle
                mapView.addAnnotation(annotation!)
                return
            }
        }
    }
    
    private func squareFrom(location: CGPoint) -> CGRect {
        let length = 50.0
        return CGRect(x: Double(location.x - CGFloat(length / 2)), y: Double(location.y - CGFloat(length / 2)), width: length, height: length)
    }
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        let geoJSONURL = Bundle.main.url(forResource: "portland", withExtension: "geojson")!
        
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "portland", url: geoJSONURL)
        mapView.style().add(geoJSONSource)
        
        let styleLayer = MGLLineStyleLayer(layerIdentifier: "portland-layer", sourceIdentifier: "portland")!
        styleLayer.lineWidth = 5 as MGLStyleAttributeValue!
        styleLayer.lineColor = UIColor.blue as MGLStyleAttributeValue!
        mapView.style().add(styleLayer)
    }
    
    // MARK: - MGLMapViewDelegate methods
    
    public func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
