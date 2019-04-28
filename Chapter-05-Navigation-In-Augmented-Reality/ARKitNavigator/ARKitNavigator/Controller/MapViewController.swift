//
//  MapViewController.swift
//  ARKitNavigator
//
//  Created by Giordano Scalzo on 11/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!

    private var locationService: LocationService!

    private var currentLocation: CLLocation?

    private var press: UILongPressGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        press = UILongPressGestureRecognizer(target: self, action: #selector(handleMapTap(gesture:)))
        press.minimumPressDuration = 0.35
        mapView.addGestureRecognizer(press)

        mapView.showsUserLocation = true

        locationService = LocationService(delegate: self)
        locationService.start()
    }

    @objc
    func handleMapTap(gesture: UIGestureRecognizer) {
        if gesture.state != UIGestureRecognizer.State.began {
            return
        }
        // Get tap point on map
        let touchPoint = gesture.location(in: mapView)

        // Convert map tap point to coordinate
        let coord: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        let destinationLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)

        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            return
        }

        viewController.destinationLocation = destinationLocation
        viewController.locationService = self.locationService

        present(viewController, animated: true)
    }
}

extension MapViewController: LocationServiceDelegate {
    func locationService(_ service: LocationService, didUpdateLocation location: CLLocation) {
        defer { currentLocation = location }
        guard currentLocation == nil else {
            return
        }

        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(viewRegion, animated: false)
    }

    func locationService(_ service: LocationService, didFailWithError error: Error) {
        print("Error getting current location: \(error)")
    }
}
