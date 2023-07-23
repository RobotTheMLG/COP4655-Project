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
import UIKit
import SpriteKit
import GameplayKit

//This is the game controller
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        if let scene = GKScene(fileNamed: "GameScene") {
            
            //Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                //Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                //Present the scene
                if let view = self.view as! SKView? {
                    if let scene = SKScene(fileNamed: "GameScene") {
                            
                        //Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill
                        //Present the scene
                        view.presentScene(scene)
                    }
                    
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
                }
            }
        }
    }
    
    //Sets orientation to landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    //Hides the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
