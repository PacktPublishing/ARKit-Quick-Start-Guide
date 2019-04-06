//
//  ViewController.swift
//  ARKitFocusSquare
//
//  Created by Giordano Scalzo on 04/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    private var focusNode: SCNNode?
    private var screenCenter: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true

        sceneView.showsStatistics = true
        sceneView.debugOptions = .showFeaturePoints

        let scene = SCNScene()
        sceneView.scene = scene
        self.screenCenter = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)

        sceneView.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(viewTapped)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    @objc
    private func viewTapped(_ gesture: UITapGestureRecognizer) {
        let hit = sceneView.hitTest(screenCenter, types: .existingPlane)
        guard let transform = hit.first?.worldTransform else {
            return
        }
        let position = SCNVector3(transform.columns.3.x,
                                  transform.columns.3.y,
                                  transform.columns.3.z)

        let sphere = SCNSphere(radius: 0.05)

        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIImage(named: "rustediron-streaks_basecolor.png")
        material.roughness.contents = UIImage(named: "rustediron-streaks_roughness.png")
        material.metalness.contents = UIImage(named: "rustediron-streaks_metallic.png")
        material.normal.contents = UIImage(named: "rustediron-streaks_normal.png")
        sphere.materials = [material]

        let sphereNode = SCNNode(geometry: sphere)

        sphereNode.position = position
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }
}

extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        guard focusNode == nil else {
            return
        }

        focusNode = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusNode!)
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let screenCenter = screenCenter
            else {
                return
        }
        let hit = sceneView.hitTest(screenCenter, types: .existingPlane)

        guard let transform = hit.first?.worldTransform else {
            return
        }

        let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        focusNode?.position = position
    }
}
