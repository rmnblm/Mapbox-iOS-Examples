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
    let minimumZoomLevel: Float
    
    init(title: String, color: UIColor, predicate: NSPredicate, minimumZoomLevel: Float) {
        self.title = title
        self.color = color
        self.predicate = predicate
        self.minimumZoomLevel = minimumZoomLevel
    }
    
    // Workaround until issue #6361 is resolved
    // https://github.com/mapbox/mapbox-gl-native/issues/6361
    var styleLayer: MGLStyleLayer?
}

struct SemanticZoomingDataSource {
    let layers = [
        SemanticZoomingLayer(
            title: "Cafes",
            color: UIColor.brown,
            predicate: NSPredicate(format: "amenity == 'cafe'"),
            minimumZoomLevel: 9.0
        ),
        SemanticZoomingLayer(
            title: "Banks",
            color: UIColor.green,
            predicate: NSPredicate(format: "amenity == 'bank'"),
            minimumZoomLevel: 10.0
        ),
        SemanticZoomingLayer(
            title: "Toilets",
            color: UIColor.white,
            predicate: NSPredicate(format: "amenity == 'toilets'"),
            minimumZoomLevel: 11.0
        ),
        SemanticZoomingLayer(
            title: "Restaurants",
            color: UIColor.blue,
            predicate: NSPredicate(format: "amenity == 'restaurant'"),
            minimumZoomLevel: 12.0
        )
    ]
}
