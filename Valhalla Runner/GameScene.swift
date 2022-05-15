//
//  GameScene.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//
import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    //variables
    var gameViewControllerBridge: GameViewController!
    var score = 0 {
        didSet{
            scoreLable.text = "SCORE: \(score)"
        }
    }
            

    
    //texutres
    var backgroundTexture: SKTexture!
    var vikingTexture: SKTexture!
    var groundTexture: SKTexture!
    var skeletonTexture: SKTexture!
    
    //lable nodes
    var scoreLable = SKLabelNode()

    
    //sprite nodes
    var background = SKSpriteNode()
    var viking = SKSpriteNode()
    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    var skeleton = SKSpriteNode()
    
    //sprite objects
    var backgroundObject = SKNode()
    var vikingObject = SKNode()
    var enemyObjects = SKNode()
    var groundObjects = SKNode()
    var skyObjects = SKNode()
    var lableObjects = SKNode()
    
    //Bit masks
    var vikingGroup: UInt32 = 0x1 << 1
    var groundGroup: UInt32 = 0x1 << 2
    var enemyGroup: UInt32 = 0x1 << 3
    var skyGroup: UInt32 = 0x1 << 4
    
    //Textures Array for anim
    var runVikingTexturesArray = [SKTexture]()
    var jumpVikingTexturesArray = [SKTexture]()
    var skeletonTextureArray = [SKTexture]()
    
    //some timer
    var skeletonTimer = Timer()
    


    
    override func didMove(to view: SKView) {
        
        
        
        self.physicsWorld.contactDelegate = self
        //backgroundTextures
        backgroundTexture = SKTexture(imageNamed: "background")
        //skeleton texture
        skeletonTexture = SKTexture(imageNamed: "skeleton")
        //vikingTextures
        vikingTexture = SKTexture(imageNamed: "viking")
        
        
        //game methods
        createObjects()
        createGame()
                
    }
    func createObjects(){
        self.addChild(backgroundObject)
        self.addChild(vikingObject)
        self.addChild(enemyObjects)
        self.addChild(groundObjects)
        self.addChild(lableObjects)
        self.addChild(skyObjects)
    }
    
    func createGame(){
        createBackground()
        createViking()
        createGround()
        createSky()
        showScore()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){
            self.timerFunc()
            self.addSkeleton()
        }
        
        gameViewControllerBridge.restartGameBtn.isHidden = true
        
    }
    func showScore(){
        scoreLable.fontName = "Pixel"
        scoreLable.position = CGPoint(x: 820, y: 650)
        scoreLable.fontSize = 50
        let wait2Seconds = SKAction.wait(forDuration: 0.5)
        let incrementCounter = SKAction.run {[weak self] in self!.score += 1}
        let sequence = SKAction.sequence([wait2Seconds, incrementCounter])
        let repeatForever = SKAction.repeatForever(sequence)
        scoreLable.run(repeatForever)
        
        scoreLable.removeFromParent()
        addChild(scoreLable)
    }
    func createBackground(){
        let moveBackground = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 3)
        let replaceBackground = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
        let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackground, replaceBackground]))
        
        backgroundTexture = SKTexture(imageNamed: "background")
        for i in 0..<3 {
            background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x: size.width / 4 + backgroundTexture.size().width * CGFloat(i), y: size.height / 2)
            background.size.height = self.frame.height - 100
            background.size.width = self.frame.width + 15
            background.zPosition = -1
            background.run(moveBackgroundForever)
            backgroundObject.addChild(background)
        }
    }
    
    func createGround(){

            ground = SKSpriteNode()
            ground.size.width = 1500
            ground.size.height = self.frame.height - 600
            ground.position = CGPoint(x: self.size.width , y: self.size.height / 12)
            
            ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ground.size.width + 1000 , height: ground.size.height - 50))
            ground.physicsBody?.categoryBitMask = groundGroup
            ground.physicsBody?.contactTestBitMask = vikingGroup
            ground.physicsBody?.contactTestBitMask = vikingGroup
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.allowsRotation = false
            ground.physicsBody?.affectedByGravity = false
            
            ground.zPosition = 1

            groundObjects.addChild(ground)

    }
    func createSky(){

            sky = SKSpriteNode()
            sky.size.width = 1500
            sky.size.height = self.frame.height - 600
            sky.position = CGPoint(x: self.size.width , y: self.size.height + 9)
            
            sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ground.size.width + 1000 , height: ground.size.height - 50))
            sky.physicsBody?.categoryBitMask = groundGroup
            sky.physicsBody?.contactTestBitMask = vikingGroup
            sky.physicsBody?.contactTestBitMask = vikingGroup
            sky.physicsBody?.isDynamic = false
            sky.physicsBody?.allowsRotation = false
            sky.physicsBody?.affectedByGravity = false
            
            sky.zPosition = 1

            skyObjects.addChild(sky)
        
    }
    func addViking(vikingNode: SKSpriteNode, atPosition position: CGPoint){
        viking = SKSpriteNode (texture: vikingTexture)
        //anim
        runVikingTexturesArray = [SKTexture(imageNamed: "viking"),SKTexture(imageNamed: "viking2"),SKTexture(imageNamed: "viking3"),SKTexture(imageNamed: "viking4"),SKTexture(imageNamed: "viking5"),SKTexture(imageNamed: "viking5"),SKTexture(imageNamed: "viking6"),SKTexture(imageNamed: "viking7")]
        let vikingRunAnimation = SKAction.animate(with: runVikingTexturesArray, timePerFrame: 0.1)
        let runViking = SKAction.repeatForever(vikingRunAnimation)
        viking.run(runViking)
        
        viking.position = CGPoint(x: self.size.width / 12, y: self.size.height - 10)
        viking.zPosition = 1
        viking.size.height = 84
        viking.size.width = 120
        viking.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: viking.size.width - 40, height: viking.size.height - 30))
        
        viking.physicsBody?.categoryBitMask = vikingGroup
        viking.physicsBody?.contactTestBitMask = skyGroup | groundGroup | enemyGroup
        viking.physicsBody?.isDynamic = true
        viking.physicsBody?.allowsRotation = false
        viking.physicsBody?.affectedByGravity = true
        
        vikingObject.addChild(viking)
    }
    func createViking(){
        addViking(vikingNode: viking, atPosition: CGPoint(x: self.size.width / 5, y: vikingTexture.size().height * 2))
    }
    @objc func addSkeleton(){
        skeleton = SKSpriteNode(texture: skeletonTexture)
        let randomPosition = arc4random() % 2
        if randomPosition == 0 {
            skeleton.position = CGPoint(x: self.size.width + 50, y: self.frame.height - skeletonTexture.size().height * 6.84)
            skeleton.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: skeleton.size.width - 40, height: skeleton.size.height - 20))
            
        }
        let moveAction = SKAction.moveBy(x: -self.frame.width - 2000, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        let moveSkeletonAndRemove = SKAction.sequence([moveAction, removeAction])
        skeleton.run(moveSkeletonAndRemove)
        skeleton.physicsBody?.affectedByGravity = true
        skeleton.physicsBody?.restitution = 0
        skeleton.physicsBody?.isDynamic = false
        skeleton.physicsBody?.categoryBitMask = enemyGroup
        skeleton.physicsBody?.contactTestBitMask = vikingGroup
        skeleton.zPosition = 1
        enemyObjects.addChild(skeleton)
    }

 
    func timerFunc(){
        skeletonTimer.invalidate()
        skeletonTimer = Timer.scheduledTimer(timeInterval: 0.456, target: self, selector: #selector(GameScene.addSkeleton), userInfo: nil, repeats: true)
    }
    
    func stopGameObject(){
        enemyObjects.speed = 0
        backgroundObject.speed = 0
        vikingObject.speed = 0
        scoreLable.removeAllActions()
        
    }
    func reloadGame(){
        enemyObjects.removeAllChildren()
        vikingObject.removeAllChildren()
        scene?.isPaused = false

        enemyObjects.speed = 1
        vikingObject.speed = 1
        backgroundObject.speed = 1
        self.speed = 1
        
        score = 0
        
        showScore()
        createGround()
        createBackground()
        createViking()
        skeletonTimer.invalidate()
        timerFunc()
        
    }
}
