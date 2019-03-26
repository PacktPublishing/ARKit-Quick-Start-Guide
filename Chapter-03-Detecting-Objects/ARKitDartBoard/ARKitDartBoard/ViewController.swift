//
//  ViewController.swift
//  ARKitDartBoard
//
//  Created by Giordano Scalzo on 25/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self

        #if DEBUG
        sceneView.showsStatistics = true
        sceneView.debugOptions = .showFeaturePoints
        #endif

        sceneView.scene = SCNScene()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(gestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configuration.planeDetection = [.vertical]
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
        if let anchor = firstHit.anchor,
            let node = sceneView.node(for: anchor) {
            putTarget(at: position, eulerAngles: node.eulerAngles)
        }

        self.sceneView.scene.rootNode.enumerateChildNodes { (existingNode, _) in
            if existingNode is Wall {
                existingNode.removeFromParentNode()
            }
        }
    }

    func putTarget(at position: SCNVector3, eulerAngles: SCNVector3) {

        let planeGeometry = SCNPlane(width: 0.5, height: 0.5)
        planeGeometry.cornerRadius = planeGeometry.width / 2
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "target")
        planeGeometry.materials = [material]

        let node = SCNNode(geometry: planeGeometry)
        node.position = position
        node.eulerAngles = eulerAngles
        node.eulerAngles.x = -.pi
        sceneView.scene.rootNode.addChildNode(node)
    }

}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let plane = Wall(anchor: anchor) {
            node.addChildNode(plane)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

        let plane = node.childNodes.first as? Wall
        plane?.update(anchor: anchor)
    }
}


extension matrix_float4x4 {
    var position: SCNVector3 {
        return SCNVector3Make(columns.3.x, columns.3.y, columns.3.z)
    }
}
