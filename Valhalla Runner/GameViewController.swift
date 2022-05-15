//
//  GameViewController.swift
//  Valhalla Runner
//
//  Created by Кантик on 14.09.2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene = GameScene (size: CGSize(width: 1024, height: 768))
    @IBOutlet weak var restartGameBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        restartGameBtn.isHidden = true
        let view = self.view as! SKView

        view.ignoresSiblingOrder = true
        
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = true
        scene.gameViewControllerBridge = self
        scene.scaleMode = .aspectFill
                // Present the scene
        view.presentScene(scene)

    }
    @IBAction func restartGameButton(sender: UIButton){
        scene.reloadGame()
        restartGameBtn.isHidden = true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
