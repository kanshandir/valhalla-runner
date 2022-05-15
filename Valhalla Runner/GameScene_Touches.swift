//
//  GameScene_Touches.swift
//  Valhalla Runner
//
//  Created by Кантик on 20.09.2021.
//

import Foundation
import SpriteKit
extension GameScene{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let jumpUpAction = SKAction.moveBy(x: 0, y: 280, duration: 0.2)
        let jumpDownAction = SKAction.moveBy(x: 0, y: -40, duration: 0.2)
        let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
        viking.run(jumpSequence)

        jumpVikingTexturesArray = [SKTexture(imageNamed: "jump1"),SKTexture(imageNamed: "jump2"),SKTexture(imageNamed: "jump3"),SKTexture(imageNamed: "jump4"),SKTexture(imageNamed: "jump5")]
        let vikingJumpAnimation = SKAction.animate(with: jumpVikingTexturesArray, timePerFrame: 0.1)
        let vikingJump = SKAction.repeatForever(vikingJumpAnimation)
        viking.run(vikingJump)
    }
}
