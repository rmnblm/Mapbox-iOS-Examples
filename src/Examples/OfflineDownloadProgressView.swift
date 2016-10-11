//
//  OfflineDownloadProgressView.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 11.10.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class OfflineDownloadProgressView : UIView {
    
    weak var delegate: OfflineDownloadDelegate?
    
    var progressView: UIProgressView!
    var progressLabel: UILabel!
    
    var offlinePack: MGLOfflinePack!
    
    var resumeButton: UIButton!
    var pauseButton: UIButton!
    var stopButton: UIButton!
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        // Setup offline pack notification handlers.
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
        
        createView()
    }
    
    public func startDownload(mapView: MGLMapView) {
        // Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
        // Because tile count grows exponentially with the maximum zoom level, you should be conservative with your `toZoomLevel` setting.
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: mapView.zoomLevel, toZoomLevel: 16)
        
        // Store some data for identification purposes alongside the downloaded resources.
        let userInfo = ["name": "My Offline Pack"]
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        
        // Create and register an offline pack with the shared offline storage object.
        MGLOfflineStorage.shared().addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(error?.localizedDescription)")
                return
            }
            
            self.offlinePack = pack!
            self.resumeButtonPressed()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Button Selectors
    
    func resumeButtonPressed() {
        resumeButton.isEnabled = false
        pauseButton.isEnabled = true
        
        offlinePack.resume()
    }
    
    func pauseButtonPressed() {
        resumeButton.isEnabled = true
        pauseButton.isEnabled = false
        
        offlinePack.suspend()
    }
    
    func stopButtonPressed() {
        resumeButton.isEnabled = false
        pauseButton.isEnabled = false
        offlinePack.suspend()
        
        delegate?.didFinishDownload()
    }
    
    // MARK: - MGLOfflinePack notification handlers
    
    func offlinePackProgressDidChange(notification: NSNotification) {
        // Get the offline pack this notification is regarding,
        // and the associated user info for the pack; in this case, `name = My Offline Pack`
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
            let progress = pack.progress
            // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected
            
            // Calculate current progress percentage.
            let progressPercentage = Float(completedResources) / Float(expectedResources)
            
            progressView.progress = progressPercentage
            
            let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)
            
            // If this pack has finished, print its size and resource count.
            if completedResources == expectedResources {
                delegate?.didFinishDownload()
                // showAlert(title: "Completed", message: "Offline pack “\(userInfo["name"])” completed: \(byteCount), \(completedResources) resources")
            } else {
                progressLabel.text = "\(completedResources) of \(expectedResources) resources — \(Int(progressPercentage * 100))%."
            }
        }
    }
    
    func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let error = notification.userInfo?[MGLOfflinePackErrorUserInfoKey] as? NSError {
            progressLabel.text = "Offline pack “\(userInfo["name"])” received error: \(error.localizedFailureReason)"
        }
    }
    
    func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let maximumCount = (notification.userInfo?[MGLOfflinePackMaximumCountUserInfoKey] as AnyObject).uint64Value {
            progressLabel.text = "Offline pack “\(userInfo["name"])” reached limit of \(maximumCount) tiles."
        }
    }
    
    // MARK: - View Creation
    
    private func createView() {
        let frame = bounds.size
        
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        addSubview(blurredView)
        
        blurredView.translatesAutoresizingMaskIntoConstraints = false
        blurredView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        blurredView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        blurredView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        blurredView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        blurredView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurredView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = 64.0
        buttonStack.distribution = .equalCentering
        buttonStack.alignment = .center
        addSubview(buttonStack)
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        buttonStack.widthAnchor.constraint(equalToConstant: frame.width / 2)
        buttonStack.heightAnchor.constraint(equalToConstant: 80)
        
        resumeButton = UIButton(type: .custom)
        resumeButton.contentEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        let resumeIcon = UIImage(named: "icon-resume")!
        resumeButton.setImage(resumeIcon, for: .normal)
        resumeButton.tintColor = UIColor.lightGray
        resumeButton.addTarget(self, action: #selector(resumeButtonPressed), for: .touchDown)
        buttonStack.addArrangedSubview(resumeButton)
        
        pauseButton = UIButton(type: .custom)
        pauseButton.contentEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        let pauseIcon = UIImage(named: "icon-pause")
        pauseButton.setImage(pauseIcon, for: .normal)
        pauseButton.tintColor = UIColor.lightGray
        pauseButton.addTarget(self, action: #selector(pauseButtonPressed), for: .touchDown)
        buttonStack.addArrangedSubview(pauseButton)
        
        stopButton = UIButton(type: .custom)
        stopButton.contentEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        let stopIcon = UIImage(named: "icon-stop")!
        stopButton.setImage(stopIcon, for: .normal)
        stopButton.tintColor = UIColor.lightGray
        stopButton.addTarget(self, action: #selector(stopButtonPressed), for: .touchDown)
        buttonStack.addArrangedSubview(stopButton)
        
        progressView = UIProgressView(progressViewStyle: .default)
        addSubview(progressView)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 64.0).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: frame.width / 2).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        progressLabel = UILabel()
        addSubview(progressLabel)
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        progressLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 12.0).isActive = true
        progressLabel.widthAnchor.constraint(equalToConstant: frame.width / 2).isActive = true
        progressLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
