//
//  CollisionCategory.swift
//  ARKitDartboard
//
//  Created by Giordano Scalzo on 01/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation

struct CollisionCategory: OptionSet {
    let rawValue: Int
    static let dart = CollisionCategory(rawValue: 1 << 0) // 00...01
    static let dartboard = CollisionCategory(rawValue: 1 << 1) // 00..10
}
