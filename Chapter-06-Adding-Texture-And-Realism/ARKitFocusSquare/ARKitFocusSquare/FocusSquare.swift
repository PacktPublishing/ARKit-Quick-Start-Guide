//
//  FocusSquare.swift
//  ARKitFocusSquare
//
//  Created by Giordano Scalzo on 04/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import Foundation
import UIKit
import SceneKit


class SegmentNode: SCNNode {
    init(with color: UIColor, width: CGFloat, height: CGFloat) {
        super.init()

        let segment = SCNPlane(width: width, height: height)
        let material = SCNMaterial()
        material.diffuse.contents = color
        segment.materials = [material]
        geometry = segment
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class FocusSquare: SCNNode {

    private var size: CGFloat
    private var segmentWidth: CGFloat

    public init(size: CGFloat = 0.1, segmentWidth: CGFloat = 0.004) {
        self.size = size
        self.segmentWidth = segmentWidth
        super.init()
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        self.size = 0
        self.segmentWidth = 0
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        let distance = Float(size) / 2.0
        setupHorizontal(for: distance)
        setupVertical(for: distance)
        eulerAngles.x = -.pi/2
    }

    private func addHorizontalSegment(distanceX: Float) {
        let segmentNode = SegmentNode(with: .blue, width: segmentWidth, height: size)
        segmentNode.position.x += distanceX
        addChildNode(segmentNode)
    }

    private func addVerticalSegment(distanceY: Float) {
        let segmentNode = SegmentNode(with: .blue, width: size, height: segmentWidth)
        segmentNode.position.y += distanceY
        addChildNode(segmentNode)
    }

    private func setupHorizontal(for distance: Float) {
        addHorizontalSegment(distanceX: distance)
        addHorizontalSegment(distanceX: -distance)
    }

    private func setupVertical(for distance: Float) {
        addVerticalSegment(distanceY: distance)
        addVerticalSegment(distanceY: -distance)
    }
}
