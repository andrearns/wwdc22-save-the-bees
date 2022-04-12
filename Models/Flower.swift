//
//  File.swift
//  
//
//  Created by André Arns on 12/04/22.
//

import Foundation
import SpriteKit

struct Flower {
    var spriteNode: SKSpriteNode
    var hasPollen: Bool = true {
        didSet {
            // Set correct values
            if !hasPollen {
                self.spriteNode.physicsBody?.categoryBitMask = UInt32(8)
                self.spriteNode.physicsBody?.collisionBitMask = UInt32(0)
                self.spriteNode.physicsBody?.contactTestBitMask = UInt32(0)
            }
        }
    }
    var scene: SKScene
    
    init(imageName: String, xPosition: CGFloat, yPosition: CGFloat, scene: SKScene) {
        self.scene = scene
        self.spriteNode = SKSpriteNode(imageNamed: imageName)
        self.spriteNode.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        self.spriteNode.physicsBody?.affectedByGravity = false
        self.spriteNode.position.x = xPosition
        self.spriteNode.position.y = yPosition
        self.spriteNode.physicsBody?.isDynamic = true
        self.spriteNode.physicsBody?.categoryBitMask = UInt32(4)
        self.spriteNode.physicsBody?.collisionBitMask = UInt32(0)
        self.spriteNode.physicsBody?.contactTestBitMask = UInt32(0)
        
        let invisibleParent = SKSpriteNode()
        invisibleParent.position.x = xPosition
        invisibleParent.position.y = yPosition
        self.scene.addChild(invisibleParent)
        
        let polenNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 16, height: 16), cornerRadius: 8)
        polenNode.fillColor = UIColor.red
        polenNode.strokeColor = UIColor.red
        polenNode.position.x = 60
        invisibleParent.addChild(polenNode)
        
        invisibleParent.run(SKAction.repeatForever(SKAction.rotate(byAngle: -1, duration: 1)))
    }
}
