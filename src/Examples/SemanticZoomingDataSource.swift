//
//  SemanticZoomingDataSource.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 27.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class SemanticZoomingLayer {
    let title: String
    let color: UIColor
    let predicate: NSPredicate
    let visibleAt: Double
    
    var styleLayer: MGLCircleStyleLayer?
    
    init(title: String, color: UIColor, predicate: NSPredicate, visibleAt: Double) {
        self.title = title
        self.color = color
        self.predicate = predicate
        self.visibleAt = visibleAt
    }
    
    func validate(zoomLevel: Double) {
        print("\(title) -> zoomLevel: \(zoomLevel) / visibleAt: \(visibleAt) / displayLayer? \(zoomLevel >= visibleAt)")
        if zoomLevel >= visibleAt {
            styleLayer?.predicate = predicate
        } else {
            // Predicate always returns false to hide layer
            // Sadly, NSPredicate(value: false) doesn't work with Mapbox
            styleLayer?.predicate = NSPredicate(format: "test == 'not'")
        }
    }
    
}

struct SemanticZoomingDataSource {
    let layers = [
        SemanticZoomingLayer(
            title: "Cafes",
            color: UIColor.brown,
            predicate: NSPredicate(format: "amenity == 'cafe'"),
            visibleAt: 9.0
        ),
        SemanticZoomingLayer(
            title: "Banks",
            color: UIColor.green,
            predicate: NSPredicate(format: "amenity == 'bank'"),
            visibleAt: 10.0
        ),
        SemanticZoomingLayer(
            title: "Toilets",
            color: UIColor.white,
            predicate: NSPredicate(format: "amenity == 'toilets'"),
            visibleAt: 11.0
        ),
        SemanticZoomingLayer(
            title: "Restaurants",
            color: UIColor.blue,
            predicate: NSPredicate(format: "amenity == 'restaurant'"),
            visibleAt: 12.0
        )
    ]
}
