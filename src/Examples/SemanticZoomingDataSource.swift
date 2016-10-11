//
//  SemanticZoomingDataSource.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 27.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

struct SemanticZoomingLayer {
    let title: String
    let color: UIColor
    let predicate: NSPredicate
    let minimumZoomLevel: Float
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
