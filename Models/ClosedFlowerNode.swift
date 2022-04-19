//
//  File.swift
//  
//
//  Created by André Arns on 12/04/22.
//

import Foundation
import SpriteKit

class ClosedFlowerNode: SKSpriteNode {
    
    init(xPosition: CGFloat, yPosition: CGFloat, scale: CGFloat) {
        super.init(texture: SKTexture(imageNamed: "closedFlowerSprite"), color: .clear, size: CGSize(width: 60, height: 60))
        
        physicsBody = SKPhysicsBody(circleOfRadius: 40)
        physicsBody?.affectedByGravity = false
        position.x = xPosition
        position.y = yPosition
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = CategoryBitMask.closedFlowerCategory
        physicsBody?.collisionBitMask = UInt32(0)
        physicsBody?.contactTestBitMask = UInt32(0)
        setScale(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
