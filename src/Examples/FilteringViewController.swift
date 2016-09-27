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
    
    private let dataSource = FilteringDataSource()
    
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var tableView: UITableView!
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        loadData()
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "siliconvalley", withExtension: "geojson")!
        
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "sv", url: geoJSONURL)
        mapView.style().add(geoJSONSource)
        
        for layer in dataSource.layers {
            addLayer(layer: layer)
        }
        
        tableView.reloadData()
    }
    
    private func addLayer(layer: FilteringLayer) {
        let styleLayer = MGLCircleStyleLayer(layerIdentifier: layer.title, sourceIdentifier: "sv")!
        styleLayer.predicate = layer.predicate
        styleLayer.circleColor = layer.color
        mapView.style().add(styleLayer)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.layers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FilterViewCell else {fatalError()}
        
        let layer = dataSource.layers[(indexPath as NSIndexPath).row]
        cell.titleLabel.text  = layer.title
        cell.stateSwitch.addTarget(self, action: #selector(filterStateChanged), for: UIControlEvents.valueChanged)
        cell.stateSwitch.tag = indexPath.row
        
        return cell
    }
    
    func filterStateChanged(sender: UISwitch) {
        let layer = dataSource.layers[sender.tag]
        if (sender.isOn) {
            addLayer(layer: layer)
        } else {
            if let styleLayer = mapView.style().layer(withIdentifier: layer.title) {
                mapView.style().remove(styleLayer)
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
