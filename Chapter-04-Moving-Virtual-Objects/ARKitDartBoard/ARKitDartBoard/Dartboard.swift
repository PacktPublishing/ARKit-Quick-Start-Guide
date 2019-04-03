//
//  Dartboard.swift
//  ARKitDartboard
//
//  Created by Giordano Scalzo on 26/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class Dartboard: SCNNode {
    init(at position: SCNVector3, eulerAngles: SCNVector3) {
        super.init()

        let planeGeometry = SCNPlane(width: 0.5, height: 0.5)
        planeGeometry.cornerRadius = planeGeometry.width / 2
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "target")
        planeGeometry.materials = [material]

        let node = SCNNode(geometry: planeGeometry)
        node.position = position
        node.eulerAngles = eulerAngles
        node.eulerAngles.x = 0

        let dartboardPhisicsShape = SCNPhysicsShape(geometry: planeGeometry, options: nil)
        node.physicsBody = SCNPhysicsBody(type: .static, shape: dartboardPhisicsShape)
        node.physicsBody?.isAffectedByGravity = false
        node.physicsBody?.categoryBitMask = CollisionCategory.dartboard.rawValue
        node.physicsBody?.contactTestBitMask = CollisionCategory.dart.rawValue

        addChildNode(node)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
