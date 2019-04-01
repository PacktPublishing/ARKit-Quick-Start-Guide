//
//  ViewController.swift
//  ARKitDancingMedea
//
//  Created by Giordano Scalzo on 01/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    private var animations = [String: CAAnimation]()
    private var modelIsIdle = true

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
        loadIdleScene()
        animations["dancing"] = animation(from: "art.scnassets/Medea_Dancing", animationIdentifier: "Medea_Dancing-1")
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


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else {
            return
        }

        let location = firstTouch.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: [.boundingBoxOnly : true])

        guard hitResults.first != nil else {
            return
        }

        if(modelIsIdle) {
            playAnimation(key: "dancing")
        } else {
            stopAnimation(key: "dancing")
        }
        modelIsIdle.toggle()
    }
}

private extension ViewController {
    func loadIdleScene() {
        let idleScene = SCNScene(named: "art.scnassets/Medea_Idle.dae")!

        let node = SCNNode()
        for child in idleScene.rootNode.childNodes {
            node.addChildNode(child)
        }

        node.position = SCNVector3(0, -0.5, -0.5)
        node.scale = SCNVector3(0.03, 0.03, 0.03)

        sceneView.scene.rootNode.addChildNode(node)
    }

    func animation(from sceneName: String, animationIdentifier: String) -> CAAnimation? {
        guard let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae") else {
            return nil
        }

        guard let sceneSource = SCNSceneSource(url: sceneURL, options: nil),
            let animationObject = sceneSource.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) else {
                return nil
        }

        animationObject.repeatCount = .greatestFiniteMagnitude
        animationObject.fadeInDuration = 1
        animationObject.fadeOutDuration = 0.5

        return animationObject
    }

    func playAnimation(key: String) {
        if let animation = animations[key] {
            sceneView.scene.rootNode.addAnimation(animation, forKey: key)
        }
    }

    func stopAnimation(key: String) {
        sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
    }
}
