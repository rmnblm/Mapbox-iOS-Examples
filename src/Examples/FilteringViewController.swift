//
//  FilteringViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class FilteringViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "siliconvalley", withExtension: "geojson")!
        
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "sv", url: geoJSONURL)
        mapView.style().add(geoJSONSource)
        
        let cafeStyleLayer = MGLCircleStyleLayer(layerIdentifier: "sv-cafe-layer", sourceIdentifier: "sv")!
        cafeStyleLayer.predicate = NSPredicate(format: "amenity == 'cafe'")
        cafeStyleLayer.circleColor = UIColor.brown
        mapView.style().add(cafeStyleLayer)
        
        let bankStyleLayer = MGLCircleStyleLayer(layerIdentifier: "sv-bank-layer", sourceIdentifier: "sv")!
        bankStyleLayer.predicate = NSPredicate(format: "amenity == 'bank'")
        bankStyleLayer.circleColor = UIColor.green
        mapView.style().add(bankStyleLayer)
        
        let toiletsStyleLayer = MGLCircleStyleLayer(layerIdentifier: "sv-toilets-layer", sourceIdentifier: "sv")!
        toiletsStyleLayer.predicate = NSPredicate(format: "amenity == 'toilets'")
        toiletsStyleLayer.circleColor = UIColor.black
        mapView.style().add(toiletsStyleLayer)
        
        let restaurantStyleLayer = MGLCircleStyleLayer(layerIdentifier: "sv-restaurant-layer", sourceIdentifier: "sv")!
        restaurantStyleLayer.predicate = NSPredicate(format: "amenity == 'restaurant'")
        restaurantStyleLayer.circleColor = UIColor.blue
        mapView.style().add(restaurantStyleLayer)
    }
    
    private func addFilterButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
    }
    
    func filterTapped() {
        
    }
}
