//
//  ExampleDataSource.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 25.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit

struct Example {
    let title: String
    let detail: String
    let classPrefix: String
    
    func controller() -> UIViewController {
        let storyboard = UIStoryboard(name: classPrefix, bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else {fatalError()}
        controller.title = title
        return controller
    }
}

struct ExampleDataSource {
    let examples = [
        Example(
            title: "Async Pin Dropping",
            detail: "Parsing a GeoJSON manually and dropping pins asynchronously.",
            classPrefix: "AsyncPinDropping"
        ),
        Example(
            title: "Polygons",
            detail: "Displaying and styling city areas of Amsterdam",
            classPrefix: "Polygons"
        ),
        Example(
            title: "Clustering",
            detail: "Consolidate data that are nearby each other on the map in an aggregate form.",
            classPrefix: "Clustering"
        ),
        Example(
            title: "Filtering",
            detail: "Filter markers and update the map.",
            classPrefix: "Filtering"
        ),
        Example(
            title: "Marker Select Feedback",
            detail: "Styled annotation with direct user feedback on touch.",
            classPrefix: "MarkerSelectFeedback"
        ),
        Example(
            title: "Path Selection",
            detail: "Styled polyline with direct user feedback (workaround for issue #2082)",
            classPrefix: "PathSelection"
        ),
        Example(
            title: "Offline",
            detail: "Download an offline pack and track its progress.",
            classPrefix: "Offline"
        ),
        Example(
            title: "Geocoder",
            detail: "Search for all type of map elements using the Mapbox Geocoding service.",
            classPrefix: "Geocoder"
        )
    ]
}
