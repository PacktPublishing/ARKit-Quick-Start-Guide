//
//  ViewController.swift
//  ARKitCheese
//
//  Created by Giordano Scalzo on 24/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    private let configuration = ARWorldTrackingConfiguration()
    private var cheese: ARCheese?

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self

        #if DEBUG
        sceneView.showsStatistics = true
        sceneView.debugOptions = .showFeaturePoints
        #endif

        let scene = SCNScene()
        sceneView.scene = scene
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action:
            #selector(handleTap))
        sceneView.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    @objc
    func handleTap(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        guard let firstHit = hitTest.first else {
            return
        }

        configuration.planeDetection = []
        sceneView.session.run(configuration)

        let position = firstHit.worldTransform.position
        let node = SCNNode.diskNode(center: position)
        sceneView.scene.rootNode.addChildNode(node)
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        guard cheese == nil else {
            return
        }

        if let cheese = ARCheese(anchor: anchor) {
            self.cheese = cheese
            node.addChildNode(cheese)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

        if let cheese = node.childNodes.first as? ARCheese {
            cheese.update(anchor: anchor)
        }
    }
}

extension matrix_float4x4 {
    var position: SCNVector3 {
        return SCNVector3Make(columns.3.x, columns.3.y, columns.3.z)
    }
}
