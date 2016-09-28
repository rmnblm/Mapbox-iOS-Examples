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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding dummy annotation as a workaround to use images from resource bundle
        // See https://github.com/mapbox/mapbox-gl-native/issues/6436#issuecomment-249667206 for more infos
        for layer in dataSource.layers {
            if layer.isBundleImage {
                let point = MGLPointAnnotation()
                point.title = layer.iconName
                mapView.addAnnotation(point)
            }
        }
    }
    
    private func loadData() {
        let geoJSONURL = Bundle.main.url(forResource: "siliconvalley", withExtension: "geojson")!
        
        let geoJSONSource = MGLGeoJSONSource(sourceIdentifier: "sv", url: geoJSONURL)
        mapView.style().add(geoJSONSource)
        
        for layer in dataSource.layers {
            add(layer: layer)
        }
    }
    
    private func add(layer: FilteringLayer) {
        let styleLayer = MGLSymbolStyleLayer(layerIdentifier: layer.title, sourceIdentifier: "sv")!
        styleLayer.predicate = layer.predicate
        if (layer.isBundleImage) {
            styleLayer.iconImage = "com.mapbox.sprites.\(layer.iconName)" as MGLStyleAttributeValue!
        }
        else {
            styleLayer.iconImage = layer.iconName as MGLStyleAttributeValue!
        }
        mapView.style().add(styleLayer)
    }
    
    // MARK: MGLMapViewDelegate
    
    public func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        loadData()
    }
    
    public func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let reuseIdentifier = annotation.title!!
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier)
        
        if annotationImage == nil {
            let image = UIImage(named: annotation.title!!)!
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
        }
        
        return annotationImage
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.layers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FilteringViewCell else {fatalError()}
        
        let layer = dataSource.layers[(indexPath as NSIndexPath).row]
        cell.titleLabel.text  = layer.title
        cell.stateSwitch.addTarget(self, action: #selector(filterStateChanged), for: UIControlEvents.valueChanged)
        cell.stateSwitch.tag = indexPath.row
        
        return cell
    }
    
    func filterStateChanged(sender: UISwitch) {
        let layer = dataSource.layers[sender.tag]
        if (sender.isOn) {
            add(layer: layer)
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
        let cell = tableView.cellForRow(at: indexPath) as! FilteringViewCell
        cell.stateSwitch.setOn(!cell.stateSwitch.isOn, animated: true)
        filterStateChanged(sender: cell.stateSwitch)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
