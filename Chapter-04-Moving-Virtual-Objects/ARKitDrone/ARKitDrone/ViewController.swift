//
//  ViewController.swift
//  ARKitDrone
//
//  Created by Giordano Scalzo on 31/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    private var droneManager: DroneManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        let scene = SCNScene()
        sceneView.scene = scene
        droneManager = DroneManager(scene: scene)
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

extension ViewController: ARSCNViewDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func sessionWasInterrupted(_ session: ARSession) {
        print("Session was interrupted.")
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session interruption has ended.")
    }
}
