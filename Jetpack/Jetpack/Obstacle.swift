//
//  Obstacle.swift
//  Jetpack
//
//  Created by Kharlo Pena on 7/11/23.
//

import SpriteKit

var obstacleCategory: UInt32 = 0x1 << 0
var playerCategory: UInt32 = 0x1 << 0

class Obstacle: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "obstacle")
        super.init(texture: texture, color: .clear, size: texture.size())

        //Set up physics body
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = obstacleCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = playerCategory
        physicsBody?.isDynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
