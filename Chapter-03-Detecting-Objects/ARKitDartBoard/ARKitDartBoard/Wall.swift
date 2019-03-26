//
//  Wall.swift
//  ARKitDartBoard
//
//  Created by Giordano Scalzo on 25/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class Wall: SCNNode {
    init?(anchor: ARAnchor?) {
        guard let anchor = anchor as? ARPlaneAnchor,
            anchor.alignment == .vertical else {
            return nil
        }

        super.init()

        let scenePlaneGeometry = ARSCNPlaneGeometry(device: MTLCreateSystemDefaultDevice()!)
        scenePlaneGeometry?.update(from: anchor.geometry)

        let planeNode = SCNNode(geometry: scenePlaneGeometry)
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.5)

        addChildNode(planeNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(anchor: ARAnchor?) {
        guard let anchor = anchor as? ARPlaneAnchor else {
            return
        }
        let node = self.childNodes.first
        let planeGeometry = node?.geometry as? ARSCNPlaneGeometry
        planeGeometry?.update(from: anchor.geometry)
    }
}

