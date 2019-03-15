//
//  ViewController.swift
//  ARKitObjectPlacer
//
//  Created by Giordano Scalzo on 15/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var stateLabel: UILabel!

    private var sessionManager: ARSessionManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionManager = ARSessionManager(delegate: self)
        sceneView.delegate = sessionManager
        sceneView.session.delegate = sessionManager
        sceneView.autoenablesDefaultLighting = true

        sceneView.showsStatistics = true
        sceneView.debugOptions = [
            ARSCNDebugOptions.showWorldOrigin,
            ARSCNDebugOptions.showFeaturePoints
        ]

        sceneView.scene = SCNScene()
//        setupStaticScene()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.setupAnchorScene()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

extension ViewController: ARSessionManagerDelegate {
    func update(current trackingState: String) {
        stateLabel.text = trackingState
    }
}

private extension ViewController {
    func setupStaticScene() {
        let boxGeometry = SCNBox(width: 0.10, height: 0.10, length: 0.10, chamferRadius: 0.01)
        boxGeometry.firstMaterial?.diffuse.contents = UIColor.red
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.position = SCNVector3(0, 0, -1) // 1 meter in front
        sceneView.scene.rootNode.addChildNode(boxNode)
    }

    func setupAnchorScene() {
        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }

        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1

        let transform = currentFrame.camera.transform * translation

        let anchor = ARAnchor(name: "box", transform: transform)
        sceneView.session.add(anchor: anchor)
    }
}
