//
//  Dart.swift
//  ARKitDartboard
//
//  Created by Giordano Scalzo on 01/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
import SceneKit

class Dart: SCNNode {

    override init () {
        super.init()
        
        let sphere = SCNSphere(radius: 0.025)
        self.geometry = sphere

        let shape = SCNPhysicsShape(geometry: sphere, options: nil)

        physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        physicsBody?.isAffectedByGravity = false
        physicsBody?.categoryBitMask = CollisionCategory.dart.rawValue
        physicsBody?.contactTestBitMask = CollisionCategory.dartboard.rawValue

        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        self.geometry?.materials = [material]

        let waitAction = SCNAction.wait(duration: 4)
        let destroyAction = SCNAction.run { $0.removeFromParentNode() }
        let delayedDestroyAction = SCNAction.sequence([waitAction, destroyAction])
        runAction(delayedDestroyAction)
    }

    func hasHitTheDartboard() {
        removeAllActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
