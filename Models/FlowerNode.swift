//
//  File.swift
//  
//
//  Created by André Arns on 12/04/22.
//

import Foundation
import SpriteKit
import SwiftUI

class FlowerNode: SKSpriteNode {
    var pollenNode: SKShapeNode
    
    var hasPollen: Bool = false {
        didSet {
            if !hasPollen {
                self.pollenNode.removeFromParent()
            }
        }
    }
    
    init(xPosition: CGFloat, yPosition: CGFloat, hasPollen: Bool, scale: CGFloat, categoryBitMask: UInt32) {
        self.hasPollen = hasPollen
        pollenNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 16, height: 16), cornerRadius: 8)
        pollenNode.fillColor = UIColor(Color.beeRed)
        pollenNode.strokeColor = UIColor(Color.beeRed)
        pollenNode.position.x = 40
        pollenNode.position.y = 40
        pollenNode.physicsBody?.affectedByGravity = false
        
        super.init(texture: SKTexture(imageNamed: "redFlowerSprite"), color: .clear, size: CGSize(width: 80, height: 80))
        
        physicsBody = SKPhysicsBody(circleOfRadius: 40)
        physicsBody?.affectedByGravity = false
        position.x = xPosition
        position.y = yPosition
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.collisionBitMask = UInt32(0)
        physicsBody?.contactTestBitMask = UInt32(0)
        setScale(scale)
        
        if hasPollen {
            let invisibleParent = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: 16, height: 16))
            invisibleParent.position.x = 0
            invisibleParent.position.y = 0
            invisibleParent.physicsBody?.affectedByGravity = false
            invisibleParent.addChild(pollenNode)
            invisibleParent.run(SKAction.repeatForever(SKAction.rotate(byAngle: -1, duration: 1)))
            
            addChild(invisibleParent)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
