//
//  ARCheese.swift
//  ARKitCheese
//
//  Created by Giordano Scalzo on 24/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
import SceneKit
import ARKit


extension ARPlaneAnchor {
    var width: Float { return self.extent.x }
    var length: Float { return self.extent.z }
}

class ARCheese: SCNNode {

    init?(anchor: ARAnchor?) {
        guard let anchor = anchor as? ARPlaneAnchor,
            anchor.alignment == .horizontal else {
                return nil
        }

        super.init()

        let planeGeometry = SCNPlane(width: CGFloat(anchor.width),
                                     height: CGFloat(anchor.length))

        let material = SCNMaterial()

        material.diffuse.contents = UIColor.orange.withAlphaComponent(0.8)

        planeGeometry.materials = [material]
        let planeNode = SCNNode(geometry: planeGeometry)

        planeNode.position = SCNVector3Make(anchor.center.x, anchor.center.y, anchor.center.z);
        planeNode.eulerAngles.x = -.pi / 2
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
        let planeGeometry = node?.geometry as? SCNPlane
        planeGeometry?.width = CGFloat(anchor.width)
        planeGeometry?.height = CGFloat(anchor.length)
        node?.position = SCNVector3Make(anchor.center.x, anchor.center.y, anchor.center.z);
    }

}

extension SCNNode {
    static func diskNode(center: SCNVector3) -> SCNNode {
        let radius = CGFloat(Float.random(in: 0.05 ..< 0.15))
        let disk = SCNPlane(width: radius , height: radius)
        disk.cornerRadius = disk.width / 2
        let diskMaterial = SCNMaterial()
        diskMaterial.colorBufferWriteMask = []
        disk.materials = [diskMaterial]
        let diskNode = SCNNode(geometry: disk)
        diskNode.position = SCNVector3Make(center.x, center.y + 0.1, center.z)
        diskNode.eulerAngles.x = -.pi / 2
        // Set rendering order to present this disk in front of the other models
        diskNode.renderingOrder = -1

        return diskNode
    }
}
