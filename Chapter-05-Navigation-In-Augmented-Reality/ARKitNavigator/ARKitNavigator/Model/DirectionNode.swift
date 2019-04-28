//
//  BaseNode.swift
//  ARKitNavigator
//
//  Created by Giordano Scalzo on 13/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import SceneKit
import UIKit
import ARKit
import CoreLocation

class DirectionNode: SCNNode {
    let location: CLLocation!

    init(location: CLLocation,
         radius: CGFloat,
         color: UIColor,
         title: String? = nil) {
        
        self.location = location
        super.init()
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]

        addNode(radius: radius, color: color, title: title)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSphereNode(with radius: CGFloat, color: UIColor) -> SCNNode {
        let geometry = SCNSphere(radius: radius)
        geometry.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: geometry)
        return sphereNode
    }

    private func addNode(radius: CGFloat, color: UIColor, title: String?) {
        let sphereNode = createSphereNode(with: radius, color: color)
        addChildNode(sphereNode)

        guard let title = title else {
            return
        }

        let text = SCNText(string: title, extrusionDepth: 0.05)
        text.font = UIFont (name: "AvenirNext-Medium", size: 1)
        text.firstMaterial?.diffuse.contents = UIColor.red

        let textNode = SCNNode(geometry: text)
        let annotationNode = SCNNode()
        annotationNode.addChildNode(textNode)
        annotationNode.position = sphereNode.position
        addChildNode(annotationNode)
    }
}

