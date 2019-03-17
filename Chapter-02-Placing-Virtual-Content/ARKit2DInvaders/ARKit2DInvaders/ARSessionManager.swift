//
//  ARSessionManager.swift
//  ARKit2DInvaders
//
//  Created by Giordano Scalzo on 16/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
import ARKit
import SpriteKit

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

extension ARSessionManager: ARSKViewDelegate {
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        let labelNode = SKLabelNode(text: "👾")
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        return labelNode;
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
