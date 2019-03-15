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
