//
//  FilterDataSource.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 26.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit

struct Filter {
    let title: String
    let color: UIColor
    let predicate: NSPredicate
}

struct FilterDataSource {
    let filters = [
        Filter(
            title: "Cafes",
            color: UIColor.brown,
            predicate: NSPredicate(format: "amenity == 'cafe'")
        ),
        Filter(
            title: "Banks",
            color: UIColor.green,
            predicate: NSPredicate(format: "amenity == 'bank'")
        ),
        Filter(
            title: "Toilets",
            color: UIColor.white,
            predicate: NSPredicate(format: "amenity == 'toilets'")
        ),
        Filter(
            title: "Restaurants",
            color: UIColor.blue,
            predicate: NSPredicate(format: "amenity == 'restaurant'")
        )
    ]
}
