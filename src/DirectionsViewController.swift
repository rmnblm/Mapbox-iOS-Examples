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

class DirectionsViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet var mapView: MGLMapView!

    var waypoints = [Waypoint]()
    var task: URLSessionTask?
    
    let directions = Directions(accessToken: Bundle.main.valueFromPList(named: "Keys", key: "MAPBOX_ACCESS_TOKEN"))

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearMap))

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    func clearMap() {
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }

        waypoints.removeAll()
    }

    func handlePress(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: nil)

        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)

        waypoints.append(Waypoint(coordinate: coordinate))

        updateRoute()
    }

    func updateRoute() {
        if waypoints.count <= 1 { return }
        
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
                    self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
                }
            }
        }
    }
}
