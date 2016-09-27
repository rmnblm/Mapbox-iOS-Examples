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
    let isBundleImage: Bool
    let iconName: String
    let color: UIColor
    let predicate: NSPredicate
}

struct FilteringDataSource {
    let layers = [
        FilteringLayer(
            title: "Cafes",
            isBundleImage: false,
            iconName: "cafe-15",
            color: UIColor.brown,
            predicate: NSPredicate(format: "amenity == 'cafe'")
        ),
        FilteringLayer(
            title: "Banks",
            isBundleImage: true,
            iconName: "custom-bank",
            color: UIColor.green,
            predicate: NSPredicate(format: "amenity == 'bank'")
        ),
        FilteringLayer(
            title: "Toilets",
            isBundleImage: false,
            iconName: "toilet-15",
            color: UIColor.white,
            predicate: NSPredicate(format: "amenity == 'toilets'")
        ),
        FilteringLayer(
            title: "Restaurants",
            isBundleImage: false,
            iconName: "restaurant-15",
            color: UIColor.blue,
            predicate: NSPredicate(format: "amenity == 'restaurant'")
        )
    ]
}
