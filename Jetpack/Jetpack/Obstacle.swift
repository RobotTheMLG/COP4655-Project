//
//==========================================================================================
// PROGRAMMERS: Luis K. Pena, Waseem Hussain Syed, Jorge Cortes and David Parra
//
// CLASS: COP4655
// SECTION: RVCC
// SEMESTER: Summer 2023
// CLASSTIME: Online
//
// Project: Space CATDet is a single player game in short bursts where the player
//          will try to catch as many space fish on screen as possible in a set
//          amount of time.
//
// CERTIFICATION: I understand FIU’s academic policies, and I certify that this work is my
//                 own and that none of it is the work of any other person.
//==========================================================================================

//Imports
import SpriteKit

var obstacleCategory: UInt32 = 0x1 << 1
var playerCategory: UInt32 = 0x1 << 0

//This is the obstacle class
class Obstacle: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "SpaceFish") // Use "SpaceFish" image for the obstacle
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
