//
//  OfflineViewController.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 04.10.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class OfflineViewController: UIViewController, MGLMapViewDelegate, OfflineDownloadDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    var downloadView: OfflineDownloadProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setCenter(CLLocationCoordinate2DMake(22.27933, 114.16281), animated: false)
        mapView.zoomLevel = 13
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(startOfflinePackDownload))
    }
    
    func startOfflinePackDownload() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        setupDownloadView()
        downloadView.startDownload(mapView: mapView)
    }
    
    func setupDownloadView() {
        downloadView = OfflineDownloadProgressView(frame: view.frame)
        downloadView.delegate = self
        view.addSubview(downloadView)
        
        downloadView.translatesAutoresizingMaskIntoConstraints = false
        downloadView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        downloadView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        downloadView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        downloadView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        downloadView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        downloadView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func didFinishDownload() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        downloadView.removeFromSuperview()
    }
}
