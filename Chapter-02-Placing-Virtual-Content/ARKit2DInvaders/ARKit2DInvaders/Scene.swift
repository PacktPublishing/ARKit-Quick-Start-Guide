//
//  Scene.swift
//  ARKit2DInvaders
//
//  Created by Giordano Scalzo on 16/03/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//

import SpriteKit
import ARKit

protocol InvadersDelegate: class {
    func invaderSpawned()
    func invaderDestroyed()
}

class Scene: SKScene {
    private let bulkAliensNumber = 20
    weak var invadersDelegate: InvadersDelegate?

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            return self.createInvaders()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }

        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)
        let hit = nodes(at: location)

        if let hitAlien = hit.first,
            let anchor = sceneView.anchor(for: hitAlien) {
            let removeAction = SKAction.run {
                sceneView.session.remove(anchor: anchor)
                self.invadersDelegate?.invaderDestroyed()
            }
            let scaleDownAction = SKAction.scale(to: 0, duration: 0.3)

            let sequence = [scaleDownAction, removeAction]
            hitAlien.run(SKAction.sequence(sequence))
        }
    }
}

private extension Scene {
    func createInvaders() {
        guard let sceneView = self.view as? ARSKView else {
            return
        }

        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }

        (0..<bulkAliensNumber).forEach { _ in
            var translation = matrix_identity_float4x4
            translation.columns.3.x = Float.random(in: -0.5 ..< 0.5)
            translation.columns.3.y = Float.random(in: -0.5 ..< 0.5)
            translation.columns.3.z = Float.random(in: -0.5 ..< 0.5)
            let transform = currentFrame.camera.transform * translation

            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
            invadersDelegate?.invaderSpawned()
        }
    }
}
