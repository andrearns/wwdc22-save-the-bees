//
//  BeeScene.swift
//  WWDC22
//
//  Created by André Arns on 08/04/22.
//

import Foundation
import SpriteKit
import CoreMotion

class BeeScene: SKScene, SKPhysicsContactDelegate {
    
    private let cam = SKCameraNode()
    private let motionManager = CMMotionManager()
    private var bee: BeeNode?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        let bee = BeeNode(xPosition: self.frame.midX, yPosition: self.frame.midY)
        self.bee?.pollenNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.bee = bee
        
        addChild(bee)
        
        self.camera = cam
        
        self.setupAccelerometer()
        
        self.bee!.position = CGPoint(x: frame.midX, y: frame.midY)
        
        spawnNewFlower(xPosition: getRandomXPosition(minimumXPosition: -600, maximumXPosition: 600), yPosition: getRandomYPosition(minimumYPosition: -600, maximumYPosition: 600), hasPollen: true, scale: 1)
        spawnNewClosedFlower(xPosition: getRandomXPosition(minimumXPosition: -600, maximumXPosition: 600), yPosition: getRandomYPosition(minimumYPosition: -600, maximumYPosition: 600))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            if let currentVelocity = bee!.physicsBody?.velocity {
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 2, dy: accelerometerData.acceleration.y * 2)
                
                self.bee!.zRotation = currentVelocity.angleRadians() - CGFloat.pi/2
                self.bee!.lastFacingDirection = currentVelocity
                self.bee?.pollenNode.zRotation = currentVelocity.angleRadians() - CGFloat.pi/2
            }
        }
        
        let position = bee!.position
        cam.position = position
    }
    
    func setupAccelerometer() {
        self.motionManager.startAccelerometerUpdates()
        self.motionManager.accelerometerUpdateInterval = 0.1
    }
    
    func spawnNewFlower(xPosition: CGFloat, yPosition: CGFloat, hasPollen: Bool, scale: CGFloat) {
        let newFlower = FlowerNode(xPosition: xPosition, yPosition: yPosition, hasPollen: hasPollen, scale: scale)
        self.addChild(newFlower)
        // To do: make SKAction of the flower growing
        
    }
    
    func spawnNewClosedFlower(xPosition: CGFloat, yPosition: CGFloat) {
        let newClosedFlower = ClosedFlowerNode(xPosition: xPosition, yPosition: yPosition)
        self.addChild(newClosedFlower)
    }
    
    func getRandomXPosition(minimumXPosition: CGFloat, maximumXPosition: CGFloat) -> CGFloat {
        CGFloat.random(in: minimumXPosition...maximumXPosition)
    }
    
    func getRandomYPosition(minimumYPosition: CGFloat, maximumYPosition: CGFloat) -> CGFloat {
        CGFloat.random(in: minimumYPosition...maximumYPosition)
    }
    
    func getRandomScale() -> CGFloat {
        CGFloat.random(in: (0.5)...(1.5))
    }
    
    // Collisions
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Collect pollen
        if firstBody.categoryBitMask == UInt32(2) && secondBody.categoryBitMask == UInt32(4) {
            print("Collect pollen")
            // Remove pollen node from contacted flower
            if let flowerNode = secondBody.node as? FlowerNode {
                flowerNode.removePollenNode()
                flowerNode.hasPollen = false
            }
            
            // Add orbital pollen to the bee
            self.bee?.hasPollen = true
        }
        // Collision with closed flower
        else if firstBody.categoryBitMask == UInt32(2) && secondBody.categoryBitMask == UInt32(8) {
            print("Collision with closed flower")
            
            if bee!.hasPollen {
                print("Grow flowers")
                bee!.removePollenNode()
                
                if let closedFlowerNode = secondBody.node as? ClosedFlowerNode {
                    closedFlowerNode.texture = SKTexture(imageNamed: "redFlowerSprite")
                    closedFlowerNode.physicsBody?.categoryBitMask = UInt32(4)
                }
                
                growFlowersAfterPollination(xPosition: secondBody.node!.position.x, yPosition: secondBody.node!.position.y)
            }
        }
    }
    
    func growFlowersAfterPollination(xPosition: CGFloat, yPosition: CGFloat) {
        for _ in 0...5 {
            let randomCloseXPosition = getRandomXPosition(minimumXPosition: xPosition - 100, maximumXPosition: xPosition + 100)
            let randomCloseYPosition = getRandomYPosition(minimumYPosition: yPosition - 100, maximumYPosition: yPosition + 100)
            let randomScale = getRandomScale()
            spawnNewFlower(xPosition: randomCloseXPosition, yPosition: randomCloseYPosition, hasPollen: false, scale: randomScale)
        }
    }
}
