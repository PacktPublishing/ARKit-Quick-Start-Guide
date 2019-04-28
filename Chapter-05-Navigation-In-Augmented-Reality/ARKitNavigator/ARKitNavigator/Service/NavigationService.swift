//
//  NavigationService.swift
//  ARKitNavigator
//
//  Created by Giordano Scalzo on 12/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import MapKit
import CoreLocation

struct NavigationService {
    func directions(to destinationLocation: CLLocation, completion: @escaping ([MKRoute]) -> Void) {

        let destination = MKPlacemark(coordinate: destinationLocation.coordinate)

        let request = MKDirections.Request()
        request.destination = MKMapItem.init(placemark: destination)
        request.source = MKMapItem.forCurrentLocation()
        request.requestsAlternateRoutes = false
        request.transportType = .walking

        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            guard error == nil else {
                self.dispatch([], in: completion)
                return print("Error getting directions")
            }

            guard let response = response else {
                self.dispatch([], in: completion)
                return print("No response getting directions")
            }

            self.dispatch(response.routes, in: completion)
        }
    }
    
    private func dispatch(_ result: [MKRoute], in completion: @escaping ([MKRoute]) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
