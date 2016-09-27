//
//  FilterDataSource.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 26.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit

struct FilteringLayer {
    let title: String
    let color: UIColor
    let predicate: NSPredicate
}

struct FilteringDataSource {
    let layers = [
        FilteringLayer(
            title: "Cafes",
            color: UIColor.brown,
            predicate: NSPredicate(format: "amenity == 'cafe'")
        ),
        FilteringLayer(
            title: "Banks",
            color: UIColor.green,
            predicate: NSPredicate(format: "amenity == 'bank'")
        ),
        FilteringLayer(
            title: "Toilets",
            color: UIColor.white,
            predicate: NSPredicate(format: "amenity == 'toilets'")
        ),
        FilteringLayer(
            title: "Restaurants",
            color: UIColor.blue,
            predicate: NSPredicate(format: "amenity == 'restaurant'")
        )
    ]
}
