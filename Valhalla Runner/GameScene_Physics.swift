//
//  GameScene_Physics.swift
//  Valhalla Runner
//
//  Created by Кантик on 20.09.2021.
//

import Foundation
import SpriteKit

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == enemyGroup || contact.bodyB.categoryBitMask == enemyGroup {
            stopGameObject()
            skeletonTimer.invalidate()
            backgroundObject.removeAllActions()
            gameViewControllerBridge.restartGameBtn.isHidden = false
            
        }
        
        if contact.bodyA.categoryBitMask != groundGroup || contact.bodyB.categoryBitMask != groundGroup {
            runVikingTexturesArray = [SKTexture(imageNamed: "viking"),SKTexture(imageNamed: "viking2"),SKTexture(imageNamed: "viking3"),SKTexture(imageNamed: "viking4"),SKTexture(imageNamed: "viking5"),SKTexture(imageNamed: "viking5"),SKTexture(imageNamed: "viking6"),SKTexture(imageNamed: "viking7")]
            let vikingRunAnimation = SKAction.animate(with: runVikingTexturesArray, timePerFrame: 0.1)
            let runViking = SKAction.repeatForever(vikingRunAnimation)
            viking.run(runViking)
        }
        
    }
}
