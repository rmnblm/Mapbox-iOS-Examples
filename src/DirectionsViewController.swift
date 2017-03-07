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

    @IBOutlet weak var magnifyingMapView: MGLMapView!
    @IBOutlet var mapView: MGLMapView!

    var points = [MGLPointAnnotation]()
    var routeLines = [MGLPolyline]()

    var task: URLSessionTask?
    
    let directions = Directions(accessToken: Bundle.main.valueFromPList(named: "Keys", key: "MAPBOX_ACCESS_TOKEN"))

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearMap))

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        mapView.addGestureRecognizer(tapGestureRecognizer)

        magnifyingMapView.attributionButton.isHidden = true
        magnifyingMapView.logoView.isHidden = true
    }

    func clearMap() {
        mapView.removeAnnotations(points)
        mapView.removeAnnotations(routeLines)

        points.removeAll()
        routeLines.removeAll()
    }

    func handlePress(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: nil)

        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)

        points.append(annotation)

        updateRoute()
    }

    func updateRoute() {
        if points.count <= 1 { return }

        mapView.removeAnnotations(routeLines)

        let waypoints = points.map({ Waypoint(coordinate: $0.coordinate) })
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifier.cycling)
        options.includesSteps = true

        task?.cancel()
        task = directions.calculate(options) { [unowned self] (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }

            if let route = routes?.first, let leg = route.legs.first {
                print("Route via \(leg):")

                let distanceFormatter = LengthFormatter()
                let formattedDistance = distanceFormatter.string(fromMeters: route.distance)

                let travelTimeFormatter = DateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .short
                let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)

                print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")

                for step in leg.steps {
                    print("\(step.instructions)")
                    let formattedDistance = distanceFormatter.string(fromMeters: step.distance)
                    print("— \(formattedDistance) —")
                }


                if route.coordinateCount > 0 {
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)

                    self.mapView.addAnnotation(routeLine)
                    self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
                    self.routeLines.append(routeLine)
                }
            }
        }
    }
}

extension DirectionsViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else {
            return nil
        }

        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "routePoint") {
            return annotationView
        } else {
            let view = RouteAnnotationView(reuseIdentifier: "routePoint", size: 20)
            view.delegate = self
            return view
        }
    }
}

extension DirectionsViewController: RouteAnnotationViewDelegate {
    func dragStarted(_ annotationView: RouteAnnotationView) {
        magnifyingMapView.isHidden = false
        
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
        magnifyingMapView.isHidden = true
        updateRoute()
    }
}
