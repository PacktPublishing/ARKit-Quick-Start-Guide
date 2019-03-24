//
//  ViewController.swift
//  ARKitPlanes
//
//  Created by Giordano Scalzo on 24/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self

#if DEBUG
        sceneView.showsStatistics = true
        sceneView.debugOptions = .showFeaturePoints
#endif

        let scene = SCNScene()

        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let plane = HorizontalPlane(anchor: anchor) {
            node.addChildNode(plane)
        }
        if let plane = VerticalPlane(anchor: anchor) {
            node.addChildNode(plane)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

        if let plane = node.childNodes.first as? HorizontalPlane {
            plane.update(anchor: anchor)
        }
        if let plane = node.childNodes.first as? VerticalPlane {
            plane.update(anchor: anchor)
        }
    }
}
