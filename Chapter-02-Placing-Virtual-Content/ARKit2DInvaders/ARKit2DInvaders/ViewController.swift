//
//  ViewController.swift
//  ARKit2DInvaders
//
//  Created by Giordano Scalzo on 16/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {    
    @IBOutlet var sceneView: ARSKView!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var aliensLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    private var aliensCount: Int = 0
    private var scoreCount: Int = 0

    private var sessionManager: ARSessionManager!

    private func updateLabels() {
        aliensLabel.text = "Aliens: \(aliensCount)"
        scoreLabel.text = "Score: \(scoreCount)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sessionManager = ARSessionManager(delegate: self)
        sceneView.delegate = sessionManager
        sceneView.session.delegate = sessionManager
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true

        if let scene = Scene(fileNamed: "Scene") {
            scene.invadersDelegate = self
            sceneView.presentScene(scene)
        }
        updateLabels()
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

extension ViewController: InvadersDelegate {
    func invaderSpawned() {
        aliensCount += 1
        updateLabels()
    }

    func invaderDestroyed() {
        aliensCount -= 1
        scoreCount += 1
        updateLabels()
    }
}

