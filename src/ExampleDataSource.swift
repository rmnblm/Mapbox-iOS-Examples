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
            title: "Panning",
            detail: "Check the panning performance with a huge amount of data.",
            classPrefix: "Panning"
        ),
        Example(
            title: "Path Selection (not supported)",
            detail: "Styled path with direct user feedback on touch.",
            classPrefix: "PathSelection"
        ),
        Example(
            title: "Semantic Zooming",
            detail: "Details on demand that lets the user see different amounts of detail in a view by zooming in and out.",
            classPrefix: "SemanticZooming"
        )
    ]
}
