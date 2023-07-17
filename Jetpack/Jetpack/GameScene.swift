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
    private var isPlayerJumping = false
    private var scoreLabel: SKLabelNode!
    private var score = 0

    private let playerCategory: UInt32 = 0x1 << 0
    private let obstacleCategory: UInt32 = 0x1 << 1

    override func didMove(to view: SKView) {
        // Set up physics world
        physicsWorld.contactDelegate = self

        // Set up background
        let background = SKSpriteNode(imageNamed: "cityskyline")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.scene?.scaleMode = .resizeFill
        addChild(background)

        // Set up player
        player = SKSpriteNode(imageNamed: "catstronaut")
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(player)

        // Set up score label
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: frame.maxX - 100, y: frame.maxY - 50)
        addChild(scoreLabel)

        // Add play button
        let playButton = SKLabelNode(fontNamed: "Helvetica")
        playButton.text = ""
        playButton.fontSize = 50
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)

            if let playButton = childNode(withName: "PLAY") as? SKLabelNode {
                if playButton.contains(location) {
                    playGame()
                    playButton.removeFromParent()
                }
            }

            if !isPlayerJumping {
                jump()
                isPlayerJumping = true
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPlayerJumping {
            isPlayerJumping = false
        }
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
