//
//  CLLocationCoordinate2D+Extension.swift
//  ARKitNavigator
//
//  Created by Giordano Scalzo on 12/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import CoreLocation

struct LocationConstants {
    static let metersPerRadianLat: Double = 6373000.0
    static let metersPerRadianLon: Double = 5602900.0
}

extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension CLLocationCoordinate2D {
    func coordinate(atDistance distance: Double, bearing: Double) -> CLLocationCoordinate2D {

        // Earth radius in meters latitude
        let distRadiansLat = distance / LocationConstants.metersPerRadianLat

        // Earth radius in meters longitude
        let distRadiansLong = distance / LocationConstants.metersPerRadianLon
        let lat1 = self.latitude.toRadians()
        let lon1 = self.longitude.toRadians()
        let lat2 = asin(sin(lat1) * cos(distRadiansLat) + cos(lat1) * sin(distRadiansLat) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadiansLong) * cos(lat1), cos(distRadiansLong) - sin(lat1) * sin(lat2))
        return CLLocationCoordinate2D(latitude: lat2.toDegrees(), longitude: lon2.toDegrees())
    }

    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
