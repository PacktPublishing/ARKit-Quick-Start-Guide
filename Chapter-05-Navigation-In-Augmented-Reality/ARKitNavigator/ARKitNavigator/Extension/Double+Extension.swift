//
//  Double+Extension.swift
//  ARKitNavigator
//
//  Created by Giordano Scalzo on 12/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
extension Double {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }

    func toDegrees() -> Double {
        return self * 180.0 / .pi
    }
}
