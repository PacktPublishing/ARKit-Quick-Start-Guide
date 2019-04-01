//
//  ViewController.swift
//  ShipLoops
//
//  Created by Giordano Scalzo on 08/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    var ship: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.showsStatistics = true
        let scene = SCNScene(named: "art.scnassets/ship.scn")!

        ship = scene.rootNode.childNode(withName: "ship", recursively: false)!

        sceneView.scene = scene

        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
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

    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        let position = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(position)

        if let hitShip = hitResults.first {
            let material = hitShip.node.geometry!.firstMaterial!
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                material.emission.contents = UIColor.black
                SCNTransaction.commit()
            }
            material.emission.contents = UIColor.red
            SCNTransaction.commit()

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            let rotation = SCNMatrix4MakeRotation(Float.pi / 4, 1, 0, 0)
            ship.transform = SCNMatrix4Mult(ship.transform, rotation)
            let translation = SCNMatrix4MakeTranslation(0, 0, -1)
            ship.transform = SCNMatrix4Mult(ship.transform, translation)
            SCNTransaction.commit()
        }
    }
}
