//
//  DroneManager.swift
//  ARKitDrone
//
//  Created by Giordano Scalzo on 31/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
import SceneKit

class DroneManager {
    private let scene: SCNScene
    private var drone: SCNNode!

    init(scene: SCNScene) {
        self.scene = scene
        self.drone = drone(in: "art.scnassets/Drone.scn")

        scene.rootNode.addChildNode(drone)
        drone.position = SCNVector3(x: 0, y: 0, z: -1.5)
    }
}


private extension DroneManager {
    func drone(in sceneName: String) -> SCNNode {
        let scene = SCNScene(named: sceneName)!
        let drone = scene.rootNode.childNode(withName: "drone", recursively: false)!
        drone.eulerAngles.x = .pi/2

        return drone
    }
//    func setup() {
//        drone = nodeWithModelName("art.scnassets/Drone.scn")
//        styleDrone()
//        spinBlades()
//        scene.rootNode.addChildNode(drone)
//        drone.position = SCNVector3(x: 0, y: 0, z: -3)
//    }
}
