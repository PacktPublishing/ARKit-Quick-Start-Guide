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
    private var blade1Node: SCNNode!
    private var blade2Node: SCNNode!

    init(scene: SCNScene) {
        self.scene = scene
        self.drone = drone(in: "art.scnassets/Drone.scn")
        applyStyle()

        scene.rootNode.addChildNode(drone)
        drone.position = SCNVector3(x: 0, y: 0, z: -1.5)
        spinBlades()
        setupBlades()

        //        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //            self.moveDrone()
        //        }
    }
}

extension DroneManager {
    func moveLeft() {
        rotateBladesLeft(duration: 1.5)
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5

        let xPosition = drone.position.x
        let yPosition = drone.position.y
        let zPosition = drone.position.z

        drone.position = SCNVector3(xPosition - 0.5, yPosition, zPosition)
        SCNTransaction.commit()
        rotateBladesRight(duration: 0.25)
    }
    func moveRight() {
        rotateBladesRight(duration: 1.5)
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5

        let xPosition = drone.position.x
        let yPosition = drone.position.y
        let zPosition = drone.position.z

        drone.position = SCNVector3(xPosition + 0.5, yPosition, zPosition)
        SCNTransaction.commit()
        rotateBladesLeft(duration: 0.25)
    }
    func rotateBladesLeft(duration: TimeInterval) {
        blade2Node.runAction(SCNAction.rotateBy(x: 0, y: -0.1, z: 0,
                                                duration: duration))
        blade1Node.runAction(SCNAction.rotateBy(x: 0, y: -0.1, z: 0,
                                                duration: duration))
    }
    func rotateBladesRight(duration: TimeInterval) {
        blade2Node.runAction(SCNAction.rotateBy(x: 0, y: 0.1, z: 0,
                                                duration: duration))
        blade1Node.runAction(SCNAction.rotateBy(x: 0, y: 0.1, z: 0,
                                                duration: duration))
    }
}

extension DroneManager {
    func change(altitude value: Float) {
        let altitude = value - 0.5
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5

        let xPosition = drone.position.x
        let zPosition = drone.position.z

        drone.position = SCNVector3(xPosition, altitude, zPosition)
        SCNTransaction.commit()
    }
}

extension DroneManager {
    func moveForward() {
        rotateBladesForth(duration: 1.5)
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5

        let xPosition = drone.position.x
        let yPosition = drone.position.y
        let zPosition = drone.position.z

        drone.position = SCNVector3(xPosition, yPosition, zPosition - 0.5)
        SCNTransaction.commit()
        rotateBladesBack(duration: 0.25)
    }

    func moveReverse() {
        rotateBladesBack(duration: 1.5)
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5

        let xPosition = drone.position.x
        let yPosition = drone.position.y
        let zPosition = drone.position.z

        drone.position = SCNVector3(xPosition, yPosition, zPosition + 0.5)
        SCNTransaction.commit()
        rotateBladesForth(duration: 0.25)
    }

    func rotateBladesForth(duration: TimeInterval) {
        blade2Node.runAction(SCNAction.rotateBy(x: 0.3, y: 0, z: 0,
                                                duration: duration))
        blade1Node.runAction(SCNAction.rotateBy(x: 0.3, y: 0, z: 0,
                                                duration: duration))
    }
    func rotateBladesBack(duration: TimeInterval) {
        blade2Node.runAction(SCNAction.rotateBy(x: -0.3, y: 0, z: 0,
                                                duration: duration))
        blade1Node.runAction(SCNAction.rotateBy(x: -0.3, y: 0, z: 0,
                                                duration: duration))
    }
}


private extension DroneManager {
    func drone(in sceneName: String) -> SCNNode {
        let scene = SCNScene(named: sceneName)!
        let drone = scene.rootNode.childNode(withName: "drone", recursively: false)!
        drone.eulerAngles.x = .pi/2

        return drone
    }

    func applyStyle() {
        let bodyMaterial = SCNMaterial()
        bodyMaterial.diffuse.contents = UIColor.black
        drone.geometry?.materials = [bodyMaterial]
    }

    func moveDrone() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 2

        let rotation = SCNMatrix4MakeRotation(.pi / 2, 0.5, 0, 0)
        drone.transform = SCNMatrix4Mult(drone.transform, rotation)
        let translation = SCNMatrix4MakeTranslation(0, 0, -1)
        drone.transform = SCNMatrix4Mult(drone.transform, translation)

        SCNTransaction.commit()
    }
    func moveDroneNonAnimated() {
        let rotation = SCNMatrix4MakeRotation(.pi / 2, 0.5, 0, 0)
        drone.transform = SCNMatrix4Mult(drone.transform, rotation)
        let translation = SCNMatrix4MakeTranslation(0, 0, -1)
        drone.transform = SCNMatrix4Mult(drone.transform, translation)
    }

    func spinBlades() {
        let rotorR = drone.childNode(withName: "Rotor_R", recursively: true)
        let rotorL = drone.childNode(withName: "Rotor_L", recursively: true)

        let rotate = SCNAction.rotateBy(x: 0, y: 0, z: 200, duration: 0.5)
        let moveSequence = SCNAction.sequence([rotate])
        let moveLoop = SCNAction.repeatForever(moveSequence)

        rotorL?.runAction(moveLoop)
        rotorR?.runAction(moveLoop)
    }

    func setupBlades() {
        blade1Node = drone.childNode(withName: "Rotor_R_2", recursively: true)!
        blade2Node = drone.childNode(withName: "Rotor_L_2", recursively: true)!
    }
}
