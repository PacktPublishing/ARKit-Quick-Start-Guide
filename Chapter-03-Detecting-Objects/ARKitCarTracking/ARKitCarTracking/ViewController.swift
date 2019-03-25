//
//  ViewController.swift
//  ARKitCarTracking
//
//  Created by Giordano Scalzo on 25/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.showsStatistics = true
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()

        guard let trackedImages = ARReferenceImage
            .referenceImages(inGroupNamed: "References",
                             bundle: Bundle.main) else {
            return
        }

        configuration.detectionImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 1
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

        guard let imageAnchor = anchor as? ARImageAnchor else {
            return nil
        }

        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)

        plane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.8)
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2

        let carScene = SCNScene(named: "art.scnassets/car.scn")!
        let carNode = carScene.rootNode.childNode(withName: "car", recursively: true)!
        carNode.position = SCNVector3Zero
        carNode.eulerAngles.x = .pi / 2
        carNode.eulerAngles.z = .pi
        carNode.position.z = 0.01

        let node = SCNNode()
        planeNode.addChildNode(carNode)
        node.addChildNode(planeNode)

        return node
    }
}
