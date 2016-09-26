//
//  FilteringViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 21.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class FilteringViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  MGLMapViewDelegate {
    
    private let dataSource = FilterDataSource()
    
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
        
        for filter in dataSource.filters {
            addLayer(filter: filter)
        }
        
        tableView.reloadData()
    }
    
    private func addLayer(filter: Filter) {
        let styleLayer = MGLCircleStyleLayer(layerIdentifier: filter.title, sourceIdentifier: "sv")!
        styleLayer.predicate = filter.predicate
        styleLayer.circleColor = filter.color
        mapView.style().add(styleLayer)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FilterViewCell else {fatalError()}
        
        let filter = dataSource.filters[(indexPath as NSIndexPath).row]
        cell.titleLabel.text  = filter.title
        cell.stateSwitch.addTarget(self, action: #selector(filterStateChanged), for: UIControlEvents.valueChanged)
        cell.stateSwitch.tag = indexPath.row
        
        return cell
    }
    
    func filterStateChanged(sender: UISwitch) {
        let filter = dataSource.filters[sender.tag]
        if (sender.isOn) {
            addLayer(filter: filter)
        } else {
            if let layer = mapView.style().layer(withIdentifier: filter.title) {
                mapView.style().remove(layer)
            }
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
        let cell = tableView.cellForRow(at: indexPath) as! FilterViewCell
        cell.stateSwitch.setOn(!cell.stateSwitch.isOn, animated: true)
        filterStateChanged(sender: cell.stateSwitch)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
