//
//  ClusteringViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class ClusteringViewController: UIViewController {
    
    @IBOutlet var mapView: MGLMapView!
    
    let clusterLayers = [[1000.0, UIColor(colorLiteralRed: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1), 20.0],
                         [500.0, UIColor(colorLiteralRed: 255/255.0, green: 149/255.0, blue: 0/255.0, alpha: 1), 18.0],
                         [250.0, UIColor(colorLiteralRed: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1), 15.0],
                         [0.0, UIColor(colorLiteralRed: 76/255.0, green: 217/255.0, blue: 100/255.0, alpha: 1), 12.0]]
    
    var clusterSizeLabelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clusterSizeLabelView = UIView(frame: mapView.frame)
        view.addSubview(clusterSizeLabelView)
    }
    
    func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "mcdonalds", withExtension: "geojson")!
        
        let options = [MGLGeoJSONClusterOption: true,
                       MGLGeoJSONClusterRadiusOption: 50,
                       MGLGeoJSONClusterMaximumZoomLevelOption: 12] as [String : Any]
        
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "mcdonalds", url: geoJSONURL, options: options)
        mapView.style().add(geoJSONSource)
        
        for index in 0..<clusterLayers.count {
            let gtePredicate = NSPredicate(format: "%K >= %@", argumentArray: ["point_count", clusterLayers[index][0] as! NSNumber])
            let allPredicate = index == 0 ?
                gtePredicate :
                NSCompoundPredicate(andPredicateWithSubpredicates: [gtePredicate, NSPredicate(format: "%K < %@", argumentArray: ["point_count", clusterLayers[index - 1][0] as! NSNumber])])
            
            let circleBorder = MGLCircleStyleLayer(layerIdentifier: "cluster-\(index)-border", source: geoJSONSource)
            circleBorder.circleColor = UIColor.white
            circleBorder.circleRadius = (clusterLayers[index][2] as! Double * 1.2) as MGLStyleAttributeValue
            circleBorder.predicate = allPredicate
            mapView.style().add(circleBorder)
            
            let circle = MGLCircleStyleLayer(layerIdentifier: "cluster-\(index)", source: geoJSONSource)
            circle.circleColor = clusterLayers[index][1] as! UIColor
            circle.circleRadius = clusterLayers[index][2] as! MGLStyleAttributeValue
            circle.predicate = allPredicate
            mapView.style().add(circle)
        }
    }
    
    
    func updateClusterSizeLabels() {
        for feature in mapView.visibleFeatures(in: view.frame, styleLayerIdentifiers: ["cluster-0", "cluster-1", "cluster-2", "cluster-3"]) {
            if feature is MGLPointFeature && feature.attributes["cluster"] as! Bool == true {
                let pointFeature = feature as! MGLPointFeature
                let clusterSize = pointFeature.attributes["point_count"] as! NSNumber
                let origin = mapView.convert(pointFeature.coordinate, toPointTo: clusterSizeLabelView)
                let label = UILabel()
                label.text = clusterSize.stringValue
                label.sizeToFit()
                label.center = origin
                label.textAlignment = .center
                label.textColor = UIColor.white
                clusterSizeLabelView.addSubview(label)
            }
        }
    }
    
    func clearClusterSizeLabels() {
        for subView in clusterSizeLabelView.subviews {
            subView.removeFromSuperview()
        }
    }
}

extension ClusteringViewController : MGLMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        loadData()
        updateClusterSizeLabels()
    }
    
    func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
        clearClusterSizeLabels()
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        updateClusterSizeLabels()
    }
}
