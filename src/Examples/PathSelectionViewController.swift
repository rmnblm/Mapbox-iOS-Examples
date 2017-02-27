//
//  PathSelectionViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class PathSelectionViewController: UIViewController {
    
    @IBOutlet var mapView: MGLMapView!
    
    var annotation: MGLPointAnnotation?
    
    var highlightedLine: MGLLineStyleLayer!
    
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
                highlightedLine.predicate = NSPredicate(format: "name == 'Crema to Council Crest'")
                return
            }
        }
        
        // If the tap wasn't on the line, unselect it
        clearHighlighting()
    }
    
    func clearHighlighting() {
        highlightedLine.predicate = NSPredicate(value: false)
    }
    
    func squareFrom(location: CGPoint) -> CGRect {
        let length = 50.0
        return CGRect(x: Double(location.x - CGFloat(length / 2)), y: Double(location.y - CGFloat(length / 2)), width: length, height: length)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        let geoJSONURL = Bundle.main.url(forResource: "portland", withExtension: "geojson")!
        
        let geoJSONSource = MGLShapeSource(identifier: "portland", url: geoJSONURL)
        mapView.style?.addSource(geoJSONSource)
        
        let styleLayer = MGLLineStyleLayer(identifier: "portland-layer", source: geoJSONSource)
        styleLayer.lineWidth = MGLStyleConstantValue(rawValue: 5)
        styleLayer.lineColor = MGLStyleConstantValue(rawValue: UIColor.gray)
        mapView.style?.addLayer(styleLayer)
        
        highlightedLine = MGLLineStyleLayer(identifier: "trackhl-layer", source: geoJSONSource)
        highlightedLine.lineWidth = MGLStyleConstantValue(rawValue: 5)
        highlightedLine.lineColor = MGLStyleConstantValue(rawValue: UIColor(colorLiteralRed: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1) )
        highlightedLine.predicate = NSPredicate(value: false)
        mapView.style?.addLayer(highlightedLine)
    }
}
