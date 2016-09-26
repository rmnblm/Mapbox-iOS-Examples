//
//  FilteringViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

struct Filter {
    let title: String
    var layer: MGLStyleLayer
}

class FilteringViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  MGLMapViewDelegate {
    
    var filters = [Filter]()
    
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "siliconvalley", withExtension: "geojson")!
        
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "sv", url: geoJSONURL)
        mapView.style().add(geoJSONSource)
        
        addLayerWithFilter(title: "Cafes", color: UIColor.brown, predicate: NSPredicate(format: "amenity == 'cafe'"))
        addLayerWithFilter(title: "Banks", color: UIColor.green, predicate: NSPredicate(format: "amenity == 'bank'"))
        addLayerWithFilter(title: "Toilets", color: UIColor.white, predicate: NSPredicate(format: "amenity == 'toilets'"))
        addLayerWithFilter(title: "Restaurants", color: UIColor.blue, predicate: NSPredicate(format: "amenity == 'restaurant'"))
        
        tableView.reloadData()
    }
    
    private func addLayerWithFilter(title: String, color: UIColor, predicate: NSPredicate) {
        let styleLayer = MGLCircleStyleLayer(layerIdentifier: "sv-" + title + "-layer", sourceIdentifier: "sv")!
        styleLayer.predicate = predicate
        styleLayer.circleColor = color
        mapView.style().add(styleLayer)
        
        let filter = Filter(title: title, layer: styleLayer)
        filters.append(filter)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FilterViewCell else {fatalError()}
        
        let filter = filters[(indexPath as NSIndexPath).row]
        cell.titleLabel.text  = filter.title
        cell.stateSwitch.addTarget(self, action: #selector(filterStateChanged), for: UIControlEvents.valueChanged)
        cell.stateSwitch.tag = indexPath.row
        
        return cell
    }
    
    func filterStateChanged(sender: UISwitch) {
        let filter = filters[sender.tag]
        if (sender.isOn) {
            mapView.style().add(filter.layer)
        } else {
            mapView.style().remove(filter.layer)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
