//
//  ClusteringViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

let kClusterZoomLevel: Float = 11
let kSourceName = "mcdonalds"
let kIconName = "Pin"
let kLayerName = "restaurants"
let kLayerClusterName = "restaurants-cluster"
let kLayerPointCountName = "restaurants-cluster-pointcount"

class ClusteringViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet var mapView: MGLMapView!
    
    let layerNames = [kLayerClusterName, kLayerPointCountName, kLayerName]

    func setupMap() {
        mapView.style?.setImage(#imageLiteral(resourceName: "Pin"), forName: kIconName)

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        var options = [MGLShapeSourceOption : Any]()
        options[.clustered] = true
        options[.clusterRadius] = 100
        options[.maximumZoomLevelForClustering] = kClusterZoomLevel

        let sourceURL = Bundle.main.url(forResource: kSourceName, withExtension: "geojson")!
        let source = MGLShapeSource(identifier: kSourceName, url: sourceURL, options: options)
        mapView.style?.addSource(source)
        
        let circles = MGLCircleStyleLayer(identifier: kLayerClusterName, source: source)
        circles.circleStrokeColor = MGLStyleValue(rawValue: UIColor.white)
        circles.circleStrokeWidth = MGLStyleValue(rawValue: 1)
        circles.circleColor = MGLStyleValue(
            interpolationMode: .interval,
            sourceStops: [
                0: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 76/255.0, green: 217/255.0, blue: 100/255.0, alpha: 1)),
                100: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1)),
                300: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 255/255.0, green: 149/255.0, blue: 0/255.0, alpha: 1)),
                1000: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1))],
            attributeName: "point_count",
            options: nil)
        circles.circleRadius = MGLStyleValue(
            interpolationMode: .interval,
            sourceStops: [
                0: MGLStyleValue(rawValue: 12),
                100: MGLStyleValue(rawValue: 15),
                300: MGLStyleValue(rawValue: 18),
                1000: MGLStyleValue(rawValue: 20)],
            attributeName: "point_count",
            options: nil)
        circles.predicate = NSPredicate(format: "%K == YES", argumentArray: ["cluster"])
        mapView.style?.addLayer(circles)
        
        var symbols = MGLSymbolStyleLayer(identifier: kLayerPointCountName, source: source)
        symbols.text = MGLStyleValue(rawValue: "{point_count}")
        symbols.textColor = MGLStyleValue(rawValue: UIColor.white)
        mapView.style?.addLayer(symbols)
        
        symbols = MGLSymbolStyleLayer(identifier: kLayerName, source: source)
        symbols.iconImageName = MGLStyleValue.init(rawValue: NSString(string: kIconName))
        symbols.iconAllowsOverlap = MGLStyleValue(rawValue: NSNumber(value: true))
        symbols.predicate = NSPredicate(format: "%K != YES", argumentArray: ["cluster"])
        mapView.style?.addLayer(symbols)
    }
}
