//
//  File.swift
//  
//
//  Created by André Arns on 12/04/22.
//

import Foundation
import SpriteKit
import SwiftUI

class BeeNode: SKSpriteNode {
    var pollenNode: SKShapeNode
    
    var lastFacingDirection: CGVector = CGVector(dx: 0, dy: 0) {
        didSet {
            if lastFacingDirection == .zero {
                lastFacingDirection = oldValue
            }
        }
    }
    
    var hasPollen: Bool = false {
        didSet {
            if hasPollen {
                self.pollenNode.alpha = 1
            } else {
                self.pollenNode.alpha = 0
            }
        }
    }
    
    init(xPosition: CGFloat, yPosition: CGFloat) {
        
        pollenNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 16, height: 16), cornerRadius: 8)
        pollenNode.fillColor = UIColor(Color.beePollenYellow)
        pollenNode.lineWidth = 2
        pollenNode.strokeColor = UIColor(Color.beeYellow)
        pollenNode.alpha = 0
        pollenNode.position.x = xPosition
        pollenNode.position.y = yPosition
        pollenNode.physicsBody?.affectedByGravity = false
        
        super.init(texture: SKTexture(imageNamed: "beeSprite"), color: .clear, size: CGSize(width: 169, height: 165))
        
        physicsBody = SKPhysicsBody(circleOfRadius: 40)
        physicsBody?.allowsRotation = true
        physicsBody?.restitution = 0.5
        zPosition = 1000
        physicsBody?.categoryBitMask = CategoryBitMask.beeCategory
        physicsBody?.collisionBitMask = UInt32(1)
        physicsBody?.contactTestBitMask = UInt32(15)
        
        let invisibleParent = SKSpriteNode()
        invisibleParent.position.x = xPosition
        invisibleParent.position.y = yPosition
        invisibleParent.addChild(pollenNode)
        invisibleParent.physicsBody?.affectedByGravity = false
        invisibleParent.run(SKAction.repeatForever(SKAction.rotate(byAngle: -1, duration: 1)))
        
        addChild(invisibleParent)
    }
    
    func removePollen() {
        self.pollenNode.alpha = 0
        self.hasPollen = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
