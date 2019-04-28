//
//  MKMultiPoint+Extension.swift
//  ARKitNavigator
//
//  Created by Giordano Scalzo on 13/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
import MapKit

public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)

        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))

        return coords
    }
}
