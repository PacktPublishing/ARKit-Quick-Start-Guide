//
//  ViewController.swift
//  ARKitDartboard
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
    private var dartboardPlaced = false

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
        // DA AGGIUNGERE
        sceneView.scene.physicsWorld.contactDelegate = self
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
        guard !dartboardPlaced else {
            throwDart()
            return
        }

        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        guard let firstHit = hitTest.first else {
            return
        }

        configuration.planeDetection = []
        sceneView.session.run(configuration)


        if let anchor = firstHit.anchor,
            let wall = sceneView.node(for: anchor) {
            let position = firstHit.worldTransform.position
            let dartBoard = Dartboard(at: position, eulerAngles: wall.eulerAngles)
            sceneView.scene.rootNode.addChildNode(dartBoard)
            dartboardPlaced = true
        }

        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node is Wall {
                node.parent?.removeFromParentNode()
            }
        }
    }
}

private extension ViewController {
    func throwDart() {
        
        let dartsNode = Dart()
        if let frame = self.sceneView.session.currentFrame {
            let cameraTransform = SCNMatrix4(frame.camera.transform)
            let dartDirection = SCNVector3(-1 * cameraTransform.m31, -1 * cameraTransform.m32, -1 * cameraTransform.m33)
            dartsNode.position = SCNVector3(cameraTransform.m41, cameraTransform.m42, cameraTransform.m43)
            dartsNode.physicsBody?.applyForce(dartDirection, asImpulse:
                true)
            sceneView.scene.rootNode.addChildNode(dartsNode)
        }
    }
}

// Mark - SCNPhysicsContactDelegate
extension ViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let contactNodes = [contact.nodeA, contact.nodeB]

        guard contactNodes.contains(where: {
            return $0.physicsBody!.categoryBitMask & CollisionCategory.dartboard.rawValue != 0
        }) else {
            return
        }

        guard let dart = contactNodes.first(where: {
            return $0.physicsBody!.categoryBitMask & CollisionCategory.dart.rawValue != 0
        }) as? Dart else {
            return
        }

        dart.physicsBody?.type = .static
        dart.hasHitTheDartboard()
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
