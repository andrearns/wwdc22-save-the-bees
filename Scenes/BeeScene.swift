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
    private var flyingAnimation: SKAction!
    
    override func didMove(to view: SKView) {
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGPath(ellipseIn: CGRect(x: -960, y: -960, width: 1920, height: 1920), transform: .none))
        physicsWorld.contactDelegate = self
        
        let bee = BeeNode(xPosition: self.frame.midX, yPosition: self.frame.midY)
        self.bee?.pollenNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.bee = bee
        self.bee?.physicsBody?.affectedByGravity = false
        
        addChild(bee)
        
        setupFlyingAnimation()
        self.bee?.run(flyingAnimation)
        
        self.camera = cam
        
        self.setupAccelerometer()
        
        self.bee!.position = CGPoint(x: frame.midX, y: frame.midY)
        
        // Review -> This depends of the current stage
        for _ in 0...2 {
            spawnNewFlower(xPosition: getRandomXPosition(minimumXPosition: -600, maximumXPosition: 600), yPosition: getRandomYPosition(minimumYPosition: -600, maximumYPosition: 600), hasPollen: true, categoryBitMask: UInt32(4))
            spawnNewClosedFlower(xPosition: getRandomXPosition(minimumXPosition: -600, maximumXPosition: 600), yPosition: getRandomYPosition(minimumYPosition: -600, maximumYPosition: 600))
        }
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
    
    // MARK: - Bee animation
    func setupFlyingAnimation() {
        var flyingTextureList: [SKTexture] = []
        
        for i in 1...6 {
            flyingTextureList.append(SKTexture(imageNamed: "beeAnimation\(i)"))
        }
        
        flyingAnimation = SKAction.repeatForever(SKAction.animate(with: flyingTextureList, timePerFrame: 0.03))
    }
    
    // MARK: - Accelerometer
    func setupAccelerometer() {
        self.motionManager.startAccelerometerUpdates()
        self.motionManager.accelerometerUpdateInterval = 0.1
    }
    
    // MARK: - Collisions
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
            if bee!.hasPollen == false {
                print("Collect pollen")
                // Remove pollen node from contacted flower
                if let flowerNode = secondBody.node as? FlowerNode {
                    flowerNode.hasPollen = false
                }
                
                // Add orbital pollen to the bee
                self.bee?.hasPollen = true
            }
        }
        // Collision with closed flower
        else if firstBody.categoryBitMask == UInt32(2) && secondBody.categoryBitMask == UInt32(8) {
            print("Collision with closed flower")
            
            if bee!.hasPollen {
                print("Grow flowers")
                bee!.removePollen()
                
                if let closedFlowerNode = secondBody.node as? ClosedFlowerNode {
                    closedFlowerNode.texture = SKTexture(imageNamed: "redFlowerSprite")
                    closedFlowerNode.physicsBody?.categoryBitMask = UInt32(16)
                }
                
                growFlowersAfterPollination(xPosition: secondBody.node!.position.x, yPosition: secondBody.node!.position.y)
            }
        }
    }
    
    // MARK: - Flowers
    func growFlowersAfterPollination(xPosition: CGFloat, yPosition: CGFloat) {
        for _ in 0...6 {
            let randomCloseXPosition = getRandomXPosition(minimumXPosition: xPosition - 100, maximumXPosition: xPosition + 100)
            let randomCloseYPosition = getRandomYPosition(minimumYPosition: yPosition - 100, maximumYPosition: yPosition + 100)
            spawnNewFlower(xPosition: randomCloseXPosition, yPosition: randomCloseYPosition, hasPollen: false, categoryBitMask: UInt32(16))
        }
    }
    
    func spawnNewFlower(xPosition: CGFloat, yPosition: CGFloat, hasPollen: Bool, categoryBitMask: UInt32) {
        let newFlower = FlowerNode(xPosition: xPosition, yPosition: yPosition, hasPollen: hasPollen, scale: 0, categoryBitMask: categoryBitMask)
        self.addChild(newFlower)
        
        // SKAction to make the flower grow
        let action = SKAction.scale(to: getRandomScale(), duration: 1)
        newFlower.run(action)
    }
    
    func spawnNewClosedFlower(xPosition: CGFloat, yPosition: CGFloat) {
        let newClosedFlower = ClosedFlowerNode(xPosition: xPosition, yPosition: yPosition)
        self.addChild(newClosedFlower)
        
        // SKAction to make the closed flower grow
        let action = SKAction.scale(to: getRandomScale(), duration: 1)
        newClosedFlower.run(action)
    }
    
    func getRandomXPosition(minimumXPosition: CGFloat, maximumXPosition: CGFloat) -> CGFloat {
        CGFloat.random(in: minimumXPosition...maximumXPosition)
    }
    
    func getRandomYPosition(minimumYPosition: CGFloat, maximumYPosition: CGFloat) -> CGFloat {
        CGFloat.random(in: minimumYPosition...maximumYPosition)
    }
    
    func getRandomScale() -> CGFloat {
        CGFloat.random(in: (0.8)...(1.2))
    }
}
