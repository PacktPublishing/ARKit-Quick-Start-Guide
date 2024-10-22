//
//  VerticalPlane.swift
//  ARKitPlanes
//
//  Created by Giordano Scalzo on 24/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class VerticalPlane: SCNNode {

    init?(anchor: ARAnchor?) {
        guard let anchor = anchor as? ARPlaneAnchor,
            anchor.alignment == .vertical else {
            return nil
        }

        super.init()

        let planeGeometry = SCNPlane(width: CGFloat(anchor.width),
                                     height: CGFloat(anchor.length))
        let material = SCNMaterial()

        material.diffuse.contents = UIImage(named:"vertical_grid.png")

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
