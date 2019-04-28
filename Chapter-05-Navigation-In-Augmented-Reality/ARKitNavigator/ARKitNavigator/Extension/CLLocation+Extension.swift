//
//  CLLocation+Extension.swift
//  ARKitNavigator
//
//  Created by Giordano Scalzo on 12/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
import CoreLocation
import GLKit
import SceneKit

extension CLLocation {
    func intermediaryLocations(to destinationLocation: CLLocation) -> [CLLocation] {
        var locations = [CLLocation]()
        let metersIntervalPerNode: Double = 10
        var distance: Double = destinationLocation.distance(from: self)
        let bearingToDestination: Double = bearing(to: destinationLocation)

        while distance > metersIntervalPerNode {
            distance -= metersIntervalPerNode
            let newLocation = coordinate.coordinate(atDistance: distance, bearing: bearingToDestination)
            if !locations.contains(newLocation.location) {
                locations.append(newLocation.location)
            }
        }
        return locations
    }

    func bearing(to destination: CLLocation) -> Double {

        let lat1 = coordinate.latitude.toRadians()
        let lon1 = coordinate.longitude.toRadians()

        let lat2 = destination.coordinate.latitude.toRadians()
        let lon2 = destination.coordinate.longitude.toRadians()
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x)
        return radiansBearing
    }


    static func bestLocationEstimate(locations: [CLLocation]) -> CLLocation {
        let sortedLocationEstimates = locations.sorted(by: {
            if $0.horizontalAccuracy == $1.horizontalAccuracy {
                return $0.timestamp > $1.timestamp
            }
            return $0.horizontalAccuracy < $1.horizontalAccuracy
        })
        return sortedLocationEstimates.first!
    }
}
