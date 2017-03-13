//
//  Directions.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 02.03.17.
//  Copyright © 2017 rmnblm. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections

let kMinimumMagnificationZoomLevel: Double = 15.0

class DirectionsViewController: UIViewController {

    @IBOutlet weak var magMapViewContainer: UIView!
    @IBOutlet weak var magnifyingMapView: MGLMapView!
    @IBOutlet var mapView: MGLMapView!

    var points = [MGLPointFeature]()
    var task: URLSessionTask?
    
    let directions = Directions(accessToken: Bundle.main.valueFromPList(named: "Keys", key: "MAPBOX_ACCESS_TOKEN"))

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearMap))

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        recognizer.delegate = self
        mapView.addGestureRecognizer(recognizer)

        magnifyingMapView.attributionButton.isHidden = true
        magnifyingMapView.logoView.isHidden = true

        magMapViewContainer.layer.shadowColor = UIColor.black.cgColor
        magMapViewContainer.layer.shadowOpacity = 0.5
        magMapViewContainer.layer.shadowRadius = 12.0
    }

    func clearMap() {
        mapView.removeAnnotations(points)

        resetRoute()
        points.removeAll()
    }

    func resetRoute(_ shape: MGLShape? = nil) {
        guard let source = mapView.style?.source(withIdentifier: "route-lines-source") as? MGLShapeSource else {
            return
        }

        source.shape = shape
    }

    func handlePress(_ recognizer: UITapGestureRecognizer) {
        let touchPoint = recognizer.location(in: mapView)
        let touchRect = CGRect(origin: touchPoint, size: .zero).insetBy(dx: -22.0, dy: -22.0) // 44x44 square
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: nil)

        if let _ = mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: ["com.mapbox.annotations.points"]).first {
            // do nothing
        } else if let feature = mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: ["route-lines"]).first {
            let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)

            let addAction = UIAlertAction(title: "Add Point to Route", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.insertRoutePoint(coordinate)
            })

            let divideAction = UIAlertAction(title: "Divide Route", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                guard let startPointId = feature.attribute(forKey: "startPointId") as? String,
                    let index = self.points.index(where: { ($0.attribute(forKey: "id") as? String) == startPointId }) else {
                    return
                }

                self.insertRoutePoint(coordinate, at: index + 1)
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                return
            })

            optionMenu.addAction(addAction)
            optionMenu.addAction(divideAction)
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true, completion: nil)
        } else {
            insertRoutePoint(coordinate)
        }
    }

    func insertRoutePoint(_ coordinate: CLLocationCoordinate2D, at index: Int? = nil) {
        let annotation = MGLPointFeature()
        annotation.coordinate = coordinate
        annotation.attributes = ["id": UUID().uuidString]
        mapView.addAnnotation(annotation)

        if let index = index {
            points.insert(annotation, at: index)
        } else {
            points.append(annotation)
        }

        self.updateRoute()
    }

    func updateRoute() {
        resetRoute()

        if points.count <= 1 { return }

        let waypoints = points.map({ Waypoint(coordinate: $0.coordinate) })
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifier.cycling)
        options.includesSteps = true

        task?.cancel()
        task = directions.calculate(options) { [unowned self] (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }

            if let route = routes?.first {
                var shapes = [MGLPolylineFeature]()
                var routeCoordinates = [CLLocationCoordinate2D]()

                for (index, leg) in route.legs.enumerated() {
                    let stepCoordinates = leg.steps.flatMap({ $0.coordinates }).reduce([CLLocationCoordinate2D](), { $0 + $1 })
                    let routeLine = MGLPolylineFeature(coordinates: stepCoordinates, count: UInt(stepCoordinates.count))
                    routeLine.attributes = [
                        "id": UUID().uuidString,
                        "startPointId": self.points[index].attribute(forKey: "id")!
                    ]
                    shapes.append(routeLine)
                    routeCoordinates.append(contentsOf: stepCoordinates)
                }

                let shapeCollection = MGLShapeCollectionFeature(shapes: shapes)
                self.resetRoute(shapeCollection)
                self.mapView.setVisibleCoordinates(&routeCoordinates, count: UInt(routeCoordinates.count), edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
            }
        }
    }

}

extension DirectionsViewController: MGLMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        let lineSource = MGLShapeSource(identifier: "route-lines-source", features: [MGLPolylineFeature](), options: nil)
        mapView.style?.addSource(lineSource)
        
        let lines = MGLLineStyleLayer(identifier: "route-lines", source: lineSource)
        lines.lineColor = MGLStyleValue(rawValue: UIColor.red)
        lines.lineWidth = MGLStyleValue(
            interpolationMode: .exponential,
            cameraStops: [
                1: MGLStyleValue(rawValue: 2),
                20: MGLStyleValue(rawValue: 40)
            ],
            options: [
                .interpolationBase: 1.5
            ])

        mapView.style?.addLayer(lines)
    }

    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let feature = annotation as? MGLPointFeature,
            let id = feature.attribute(forKey: "id") as? String else {
            return nil
        }

        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "routePoint") {
            return annotationView
        } else {
            let view = RouteAnnotationView(reuseIdentifier: "routePoint", size: 20)
            view.identifier = id
            view.delegate = self
            return view
        }
    }

    func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
        guard let routeAnnotationView = annotationView as? RouteAnnotationView,
            let annotation = annotationView.annotation else {
            return
        }

        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            guard let id = routeAnnotationView.identifier,
                let index = self.points.index(where: { ($0.attribute(forKey: "id") as? String) == id }) else {
                    return
            }

            self.mapView.removeAnnotation(annotation)
            self.points.remove(at: index)
            self.updateRoute()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)

        self.present(optionMenu, animated: true, completion: nil)
    }
}

extension DirectionsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DirectionsViewController: RouteAnnotationViewDelegate {
    func dragStarted(_ annotationView: RouteAnnotationView) {
        magMapViewContainer.isHidden = false

        if mapView.zoomLevel > kMinimumMagnificationZoomLevel {
            magnifyingMapView.zoomLevel = mapView.zoomLevel
        } else {
            magnifyingMapView.zoomLevel = kMinimumMagnificationZoomLevel
        }
    }

    func didDrag(_ annotationView: RouteAnnotationView) {
        let centerCoordinate = mapView.convert(annotationView.center, toCoordinateFrom: nil)
        magnifyingMapView.centerCoordinate = centerCoordinate
    }

    func dragEnded(_ annotationView: RouteAnnotationView) {
        magMapViewContainer.isHidden = true
        updateRoute()
    }
}
