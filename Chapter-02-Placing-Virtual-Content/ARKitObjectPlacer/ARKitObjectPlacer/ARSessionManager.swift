//
//  ARSessionManager.swift
//  ARKitObjectPlacer
//
//  Created by Giordano Scalzo on 15/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

protocol ARSessionManagerDelegate: class {
    func update(current trackingState: String)
}

class ARSessionManager: NSObject {
    weak var delegate: ARSessionManagerDelegate?

    init(delegate: ARSessionManagerDelegate?) {
        self.delegate = delegate
        super.init()
    }
}

extension ARSessionManager: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for
        anchor: ARAnchor) {
//        if anchor.name == "box" {
//            let boxGeometry = SCNBox(width: 0.10, height: 0.20, length: 0.30, chamferRadius: 0.01)
//            boxGeometry.firstMaterial?.diffuse.contents = UIColor.green
//            let boxNode = SCNNode(geometry: boxGeometry)
//            node.addChildNode(boxNode)
//        }
        //        let boxGeometry = SCNBox(width: 0.10, height: 0.10, length: 0.10, chamferRadius: 0.01)
        //        boxGeometry.firstMaterial?.diffuse.contents = .red
        //        let boxNode = SCNNode(geometry: boxGeometry)
        //        planeNode.position = self.position(from: anchor)

        //        let centerX = anchor.center.x
        //        let centerZ = anchor.center.z
        //        return SCNVector3Make(centerX, -0.55, centerZ)

        //        DispatchQueue.main.async {
        //            if let planeAnchor = anchor as? ARPlaneAnchor {
        //                let newNode = PlaneGenerator.getPlane(from: planeAnchor)
        //                node.addChildNode(newNode)
        //                self.delegate?.planeNode(is: true, planeAnchor:
        //                    planeAnchor)
        //            }
        //        }
    }
}


extension ARSessionManager: ARSessionDelegate {
    func session(_ session: ARSession, cameraDidChangeTrackingState camera:
        ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            delegate?.update(current: "Tracking unavailable")
        case .normal:
            delegate?.update(current: "Tracking normal")
        case .limited(.excessiveMotion):
            delegate?.update(current: "Tracking limited - Too much camera movement")
        case .limited(.insufficientFeatures):
            delegate?.update(current: "Tracking limited - Not enough surface detail")
        case .limited(.initializing):
            delegate?.update(current: "Tracking limited - Too much camera movement")
        case .limited(.relocalizing):
            delegate?.update(current: "Tracking limited - Trying to relocalize")
        }
    }
    func session(_ session: ARSession, didFailWithError error: Error) {
        delegate?.update(current: "Tracking did fail: \(error.localizedDescription)")
    }
    func sessionWasInterrupted(_ session: ARSession) {
        delegate?.update(current: "Tracking interrupted")
    }
    func sessionInterruptionEnded(_ session: ARSession) {
        delegate?.update(current: "Tracking interruption ended")
    }
}
