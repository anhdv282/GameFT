
import SpriteKit
protocol GameDelegate {
    func transitionToOtherViewController()
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameDelegate:GameDelegate?
    func transitionToOtherViewController() {
        
    }
    // MARK: - Instance Variables
    
    let playerSpeed: CGFloat = 150.0
    let zombieSpeed: CGFloat = 75.0
    
    var goal: SKSpriteNode?
    var player: SKSpriteNode?
    var zombies: [SKSpriteNode] = []
    
    var lastTouch: CGPoint? = nil
    // MARK: - SKScene
    
    override func didMoveToView(view: SKView) {
//        self.gameDelegate = self
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        // Setup player
        player = self.childNodeWithName("player") as? SKSpriteNode
        self.listener = player
        
        // Setup zombies
        for child in self.children {
            if child.name == "ghost" {
                if let child = child as? SKSpriteNode {
                    // Add SKAudioNode to zombie
                    let audioNode: SKAudioNode = SKAudioNode(fileNamed: "fear_moan.wav")
                    child.addChild(audioNode)
                    
                    zombies.append(child)
                }
            }
        }
        
        // Setup goal
        goal = self.childNodeWithName("chest") as? SKSpriteNode
        
        // Setup initial camera position
        updateCamera()
    }
    
    
    // MARK: Touch Handling
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    private func handleTouches(touches: Set<UITouch>) {
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            lastTouch = touchLocation
        }
    }
    
    
    // MARK - Updates
    
    override func didSimulatePhysics() {
        if let _ = player {
            updatePlayer()
            updateZombies()
        }
    }
    
    // Determines if the player's position should be updated
    private func shouldMove(currentPosition currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - touchPosition.x) > player!.frame.width / 2 ||
            abs(currentPosition.y - touchPosition.y) > player!.frame.height/2
    }
    
    // Updates the player's position by moving towards the last touch made
    func updatePlayer() {
        if let touch = lastTouch {
            let currentPosition = player!.position
            if shouldMove(currentPosition: currentPosition, touchPosition: touch) {
                
                let angle = atan2(currentPosition.y - touch.y, currentPosition.x - touch.x) + CGFloat(M_PI)
                let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0)
                
                player!.runAction(rotateAction)
                
                let velocotyX = playerSpeed * cos(angle)
                let velocityY = playerSpeed * sin(angle)
                
                let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
                player!.physicsBody!.velocity = newVelocity;
                updateCamera()
            } else {
                player!.physicsBody!.resting = true
            }
        }
    }
    
    func updateCamera() {
        if let camera = camera {
            camera.position = CGPoint(x: player!.position.x, y: player!.position.y)
        }
    }
    
    // Updates the position of all zombies by moving towards the player
    func updateZombies() {
        let targetPosition = player!.position
        
        for zombie in zombies {
            let currentPosition = zombie.position
            
            let angle = atan2(currentPosition.y - targetPosition.y, currentPosition.x - targetPosition.x) + CGFloat(M_PI)
            let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
            zombie.runAction(rotateAction)
            
            let velocotyX = zombieSpeed * cos(angle)
            let velocityY = zombieSpeed * sin(angle)
            
            let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
            zombie.physicsBody!.velocity = newVelocity;
        }
    }
    
    // MARK: - SKPhysicsContactDelegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        // 1. Create local variables for two physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // 2. Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 3. react to the contact between the two nodes
        if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == zombies[0].physicsBody?.categoryBitMask {
            // Player & Zombie
            gameOver(false)
        } else if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == goal?.physicsBody?.categoryBitMask {
            // Player & Goal
            gameOver(true)
        }
    }
    
    
    // MARK: Helper Functions
    
    private func gameOver(didWin: Bool) {
        print("- - - Game Ended - - -")
//            let menuScene = MenuScene(size: self.size)
//            menuScene.soundToPlay = didWin ? "fear_win.mp3" : "fear_lose.mp3"
//            let transition = SKTransition.flipVerticalWithDuration(1.0)
//            menuScene.scaleMode = SKSceneScaleMode.AspectFill
//            self.scene!.view?.presentScene(menuScene, transition: transition)
//        presentNextVC()
        self.gameDelegate?.transitionToOtherViewController()
    }
    
    func presentNextVC() {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("OpenChestViewController") as! OpenChestViewController
        let currentViewController = (UIApplication.sharedApplication().delegate as! AppDelegate)
        currentViewController.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
}
