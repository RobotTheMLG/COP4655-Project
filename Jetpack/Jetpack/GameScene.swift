//
//  GameScene.swift
//  Jetpack
//
//  Created by Kharlo Pena on 7/11/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var player: SKSpriteNode!
    private var enemy: SKSpriteNode!
    private var isPlayerJumping = false
    private var scoreLabel: SKLabelNode!
    private var score = 0
    private var isMovingPlayer = false
    
    private let playerCategory: UInt32 = 0x1 << 0
    private let obstacleCategory: UInt32 = 0x1 << 1
    private let enemyCategory: UInt32 = 0x1 << 2
    
    override func didMove(to view: SKView) {
        
        //Calls to background, player sprite, and enemy sprite
        createBackground()
        createSprite()
        
        // Set up physics world
        physicsWorld.contactDelegate = self
        
        
        createEnemySprite()
        
        //Set up physics world
        self.physicsWorld.contactDelegate = self
        
        createEnemySprite()
        // Set up physics world
        physicsWorld.contactDelegate = self
        
        //Scrolling background
        func createBackground() {
            let backgroundTexture = SKTexture(imageNamed: "BG")
            let moveBackground = SKAction.move(by: CGVector(dx: -backgroundTexture.size().width, dy: 0), duration: 5)
            let shiftBackground = SKAction.move(by: CGVector(dx: backgroundTexture.size().width, dy: 0), duration: 0)
            let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackground, shiftBackground]))
            
            for i in 0..<2{
                let background = SKSpriteNode(texture: backgroundTexture)
                background.anchorPoint = CGPoint(x:0.5, y: 0.6)
                background.position = CGPoint(x: backgroundTexture.size().width * CGFloat(i), y: frame.midY)
                background.size.height = 720
                background.run(moveBackgroundForever)
                addChild(background)
            }
        }
        
        //Player catstronaut sprite
        func createSprite() {
            player = SKSpriteNode(imageNamed: "Catstronaut")
            player.position = CGPoint(x: frame.midX, y: frame.midY)
            self.player.zPosition = 2.0
            player.size.height = 70
            player.size.width = 70
            addChild(player)
        }
        
        //Enemey Character sprite
        func createEnemySprite() {
            enemy = SKSpriteNode(imageNamed: "UFO")
            let randomY = CGFloat.random(in: frame.minY...frame.maxY)
            enemy.position = CGPoint(x: frame.maxX + enemy.size.width, y: randomY)
            enemy.size.height = 50
            enemy.size.width = 50
            addChild(enemy)
        
            
            //Enemey space fish sprite
            func createEnemySprite() {
                enemy = SKSpriteNode(imageNamed: "SpaceFish")
                enemy.position = CGPoint(x: frame.maxX + enemy.size.width / 2, y: frame.midY)
                enemy.zPosition = 1.0
                enemy.size.height = 70
                enemy.size.width = 70
                
                //Set up physics body for the space fish
                enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2)
                enemy.physicsBody?.categoryBitMask = 0x1
                enemy.physicsBody?.collisionBitMask = 0x2 | 0x1
                enemy.physicsBody?.contactTestBitMask = 0x0
                enemy.physicsBody?.affectedByGravity = false
                enemy.physicsBody?.allowsRotation = false
                enemy.physicsBody?.restitution = 1.0 //Make the space fish bounce off the edges with full energy
                enemy.physicsBody?.linearDamping = 0 //Remove linear damping to maintain constant speed
                enemy.physicsBody?.velocity = CGVector(dx: -200, dy: 0)
                
                addChild(enemy)
                
                /*Set up physics body for the screen edges (border)
                 let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
                 self.physicsBody = borderBody
                 self.physicsBody?.categoryBitMask = 0x2
                 self.physicsBody?.collisionBitMask = 0x1
                 self.physicsBody?.contactTestBitMask = 0x0*/
                
                //Add the scene as the contact delegate
                self.physicsWorld.contactDelegate = self
            }
        }
        /*Set up score label
         
         scoreLabel = SKLabelNode(fontNamed: "Helvetica")
         scoreLabel.fontSize = 30
         scoreLabel.position = CGPoint(x: frame.maxX - 100, y: frame.maxY - 50)
         addChild(scoreLabel)
         
         // Add play button
         let playButton = SKLabelNode(fontNamed: "Helvetica")
         playButton.text = ""
         playButton.fontSize = 50
         playButton.position = CGPoint(x: frame.midX, y: frame.midY)
         addChild(playButton)*/
        
        
        //Function to touch start
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: self)
            
            if player.contains(touchLocation) {
                isMovingPlayer = true
            }
        }
        
        //Function to have catstronaut follow player touch
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: self)
            
            movePlayer(to: touchLocation)
        }
        
        //Function to stop catstronaut moving when screen is not touched
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            isMovingPlayer = false
        }
        
        //Function to move catstronaut sprite
        func movePlayer(to position: CGPoint) {
            let moveAction = SKAction.move(to: position, duration: 0.1)
            player.run(moveAction)
        }
        
        
        func playGame() {
            //Reset score
            score = 0
            scoreLabel.text = "Score: (score)"
            
            //Spawn obstacles at regular intervals
            let spawnAction = SKAction.run { [weak self] in
                self?.spawnObstacle()
            }
            let waitAction = SKAction.wait(forDuration: 1.5) // Adjust the duration as needed
            let sequenceAction = SKAction.sequence([spawnAction, waitAction])
            let repeatAction = SKAction.repeatForever(sequenceAction)
            run(repeatAction, withKey: "spawnObstacles")
            
            //Start updating the score
            let updateScoreAction = SKAction.run { [weak self] in
                self?.addScore()
            }
            let delayAction = SKAction.wait(forDuration: 1.0) // Adjust the duration as needed
            let scoreSequence = SKAction.sequence([updateScoreAction, delayAction])
            let scoreRepeatAction = SKAction.repeatForever(scoreSequence)
            run(scoreRepeatAction, withKey: "updateScore")
        }
        
        func spawnObstacle() {
            let obstacle = Obstacle()
            obstacle.position = CGPoint(x: frame.maxX + obstacle.size.width / 2, y: frame.midY)
            addChild(obstacle)
            
            let moveLeft = SKAction.moveBy(x: -(frame.size.width + obstacle.size.width), y: 0, duration: 4)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveLeft, remove])
            obstacle.run(sequence)
        }
        
        func didBegin(_ contact: SKPhysicsContact) {
            if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == obstacleCategory)
                || (contact.bodyA.categoryBitMask == obstacleCategory && contact.bodyB.categoryBitMask == playerCategory) {
                //Function to lower score of player if they hit obstacle
            } else if (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == enemyCategory)
                        || (contact.bodyA.categoryBitMask == enemyCategory && contact.bodyB.categoryBitMask == playerCategory) {
                //Function to increase player score if player touches fish
            }
        }
        
        func addScore() {
            score += 1
            scoreLabel.text = "Score: (score)"
        }
        
        /*func gameOver() {
         // Stop obstacle spawning and score updating actions
         removeAction(forKey: "spawnObstacles")
         removeAction(forKey: "updateScore")
         
         // Implement game over logic here
         // Show "Game Over" text, player score, and reset button
         }*/
        
    }
    
    //Function to touch start
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        
        
        //Function to touch start
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: self)
            
            if player.contains(touchLocation) {
                isMovingPlayer = true
            }
        }
        
        //Function to have catstronaut follow player touch
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: self)
            
            movePlayer(to: touchLocation)
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            isMovingPlayer = false
        }
        
        //Function to move catstronaut sprite
        func movePlayer(to position: CGPoint) {
            let moveAction = SKAction.move(to: position, duration: 0.1)
            player.run(moveAction)
        }
        
        
        func playGame() {
            // Reset score
            score = 0
            scoreLabel.text = "Score: (score)"
            
            // Spawn obstacles at regular intervals
            let spawnAction = SKAction.run { [weak self] in
                self?.spawnObstacle()
            }
            let waitAction = SKAction.wait(forDuration: 1.5) // Adjust the duration as needed
            let sequenceAction = SKAction.sequence([spawnAction, waitAction])
            let repeatAction = SKAction.repeatForever(sequenceAction)
            run(repeatAction, withKey: "spawnObstacles")
            
            // Start updating the score
            let updateScoreAction = SKAction.run { [weak self] in
                self?.addScore()
            }
            let delayAction = SKAction.wait(forDuration: 1.0) // Adjust the duration as needed
            let scoreSequence = SKAction.sequence([updateScoreAction, delayAction])
            let scoreRepeatAction = SKAction.repeatForever(scoreSequence)
            run(scoreRepeatAction, withKey: "updateScore")
        }
        
        func spawnObstacle() {
            let obstacle = Obstacle()
            obstacle.position = CGPoint(x: frame.maxX + obstacle.size.width / 2, y: frame.midY)
            addChild(obstacle)
            
            let moveLeft = SKAction.moveBy(x: -(frame.size.width + obstacle.size.width), y: 0, duration: 4)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveLeft, remove])
            obstacle.run(sequence)
        }
        
        func didBegin(_ contact: SKPhysicsContact) {
            if contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == obstacleCategory {
                gameOver()
            } else if contact.bodyA.categoryBitMask == obstacleCategory && contact.bodyB.categoryBitMask == playerCategory {
                gameOver()
            }
        }
        
        func addScore() {
            score += 1
            scoreLabel.text = "Score: (score)"
        }
        
        func gameOver() {
            // Stop obstacle spawning and score updating actions
            removeAction(forKey: "spawnObstacles")
            removeAction(forKey: "updateScore")
            
            // Implement game over logic here
            // Show "Game Over" text, player score, and reset button
        }
        
        func jump() {
            // Implement player jumping logic
        }
        
    }
    
}
