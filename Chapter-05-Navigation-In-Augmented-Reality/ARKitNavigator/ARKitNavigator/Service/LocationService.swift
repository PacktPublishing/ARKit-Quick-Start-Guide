//
//  LocationService.swift
//  ARKitNavigator
//
//  Created by Giordano Scalzo on 26/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import CoreLocation

protocol LocationServiceDelegate: class {
    func locationService(_ service: LocationService, didUpdateLocation location: CLLocation)
    func locationService(_ service: LocationService, didFailWithError error: Error)
}


class LocationService: NSObject {
    private let locationManager: CLLocationManager
    private(set) var currentLocation: CLLocation?
    weak var delegate: LocationServiceDelegate?


    init(delegate: LocationServiceDelegate?) {
        locationManager = CLLocationManager()
        self.delegate = delegate
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func start() {
        requestAuthorization()
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach {
            delegate?.locationService(self, didUpdateLocation: $0)
        }
        currentLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationService(self, didFailWithError: error)
    }
}

private extension LocationService {

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .notDetermined, .restricted:
            locationManager.stopUpdatingLocation()
        }
    }
}
